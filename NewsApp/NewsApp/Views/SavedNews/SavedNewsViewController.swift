//
//  SavedNewsViewController.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 01.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

class SavedNewsViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let viewModel: SavedNewsViewModel
    
    init(newsRealmManager: NewsRealmManager) {
        self.viewModel = SavedNewsViewModel(newsRealmManager: newsRealmManager)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getSavedNews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIElements
    private lazy var table: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .orange
        table.showsVerticalScrollIndicator = false
        table.rowHeight = UITableView.automaticDimension
        table.separatorStyle = .none
        table.allowsSelection = false
        table.sectionHeaderTopPadding = 0
        table.estimatedRowHeight = 200
        
        table.register(
            SavedNewsCell.self,
            forCellReuseIdentifier: SavedNewsCell.identifier
        )
        
        return table
    }()
}

private extension SavedNewsViewController {
    func configureView() {
        setBackground()
        setupSubviews()
        bindTableView()
    }
    
    func setBackground() {
        view.backgroundColor = .white
    }
    
    func setupSubviews() {
        view.addSubview(table)
        setupConstraints()
    }
    
    func setupConstraints() {
        table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        table.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        table.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func bindTableView() {
        viewModel.savedNewsSubject
            .bind(to: table.rx.items) { table, index, model in
                let cell = table.dequeueReusableCell(withIdentifier: SavedNewsCell.identifier, for: IndexPath(row: index, section: 0)) as! SavedNewsCell
                cell.viewModel = self.viewModel
                cell.news = model
                cell.configureText(text: model.title)
                if let data = model.image {
                    cell.configureImage(image: data)
                }
                
                return cell
            }
            .disposed(by: disposeBag)
    }
}
