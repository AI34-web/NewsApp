//
//  NewsViewController.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 30.06.2024.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: - Кешировать картинки и не запрашивать из сети повторно при скроле изображения
// то есть если один раз запросили картинку - она должна сохранятся и не запрашиваться повторно

// TODO: - Сделать обработку открытия новости в новом представлении(боттом шит или фуллл скрин ковер)

class NewsViewController: UIViewController {
    private let viewModel: NewsViewModel
    private let disposeBag = DisposeBag()
    private var image: UIImage?
    
    init(newsManager: NewsManagerProtocol, newsRealmManager: NewsRealmManagerProtocol) {
        self.viewModel = NewsViewModel(newsManager: newsManager, newsRealmManager: newsRealmManager)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            let articles = try viewModel.newsSubject.value()
            if articles.isEmpty {
                viewModel.fetchNews()
            }
        } catch {
            print("Ошибка получения новостей: \(error)")
        }
    }
    
    // MARK: Private lazy UIElements
    private lazy var table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .orange
        table.showsVerticalScrollIndicator = false
        table.rowHeight = UITableView.automaticDimension
        table.separatorStyle = .none
        table.allowsSelection = true
        table.sectionHeaderTopPadding = 0
//        table.estimatedRowHeight = 200
        
        table.register(
            NewsOfTheDayCell.self,
            forCellReuseIdentifier: NewsOfTheDayCell.identifier
        )
        
        table.register(
            NewsFeedCell.self,
            forCellReuseIdentifier: NewsFeedCell.identifier
        )
        
        return table
    }()
}

// MARK: - Configure view
private extension NewsViewController {
    private func configureView() {
        setBackgroundView()
        configureNavigationBar()
        setupConstraints()
        bindTableView()
    }
    
    func setBackgroundView() {
        view.backgroundColor = .white
    }
    
    func configureNavigationBar() {
        navigationItem.title = "News"
        navigationController?.navigationBar.backgroundColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.systemGreen
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .plain,
            target: self,
            action: #selector(newsOptionsOpen)
        )
    }
    
    private func bindTableView() {      
        viewModel.newsSubject
            .bind(to: table.rx.items) { table, index, model in
                if index == 0 {
                    let cell = table.dequeueReusableCell(withIdentifier: NewsOfTheDayCell.identifier, for: IndexPath(row: index, section: 0)) as! NewsOfTheDayCell
                    
                    cell.viewModel = self.viewModel
                    cell.configurationLabel(text: model.title)
                    cell.news = model
                    
                    if let urlToImage = model.urlToImage {
                        cell.configurationImage(from: urlToImage, index: index)
                    } else {
                        cell.setDefaultImage()
                    }
                    
                    return cell
                    
                } else {
                    let cell = table.dequeueReusableCell(withIdentifier: NewsFeedCell.identifier, for: IndexPath(row: index, section: 0)) as! NewsFeedCell
                    
                    cell.viewModel = self.viewModel
                    cell.configurationLabel(text: model.title)
                    cell.news = model
                    
                    if let urlToImage = model.urlToImage {
                        cell.configurationImage(from: urlToImage, index: index)
                    }
                    
                    return cell
                    
                }
            }
            .disposed(by: disposeBag)
        
        // обработка нажатия ячейки
        table.rx.modelSelected(Article.self)
            .subscribe(onNext: { [weak self] article in
                guard let self else { return }
                
                // navigations
                let newsDetail = NewsDetailsViewController(news: article, viewModel: viewModel)
                self.navigationController?.pushViewController(newsDetail, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Constraints
extension NewsViewController {
    func setupConstraints() {
        view.addSubview(table)
        
        table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

// MARK: - Actions
extension NewsViewController {
    @objc private func newsOptionsOpen() {
        let bottomSheetVC = NewsOptionsSheetViewController()
        
        if let sheet = bottomSheetVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(bottomSheetVC, animated: true, completion: nil)
    }
}
