//
//  NewsDetailsViewController.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 01.10.2024.
//

import UIKit

class NewsDetailsViewController: UIViewController {
    var image: UIImage?
    var news: Article
    var viewModel: NewsViewModel
    
    init(news: Article, viewModel: NewsViewModel) {
        self.news = news
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    // нужен если мы прописываем инициализатор
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var labelText: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.text = news.title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var labelImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = news.image
        image.layer.cornerRadius = 10
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let addToFavouritesButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(addToFavouritesAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

private extension NewsDetailsViewController {
    func configureView() {
        setupBackground()
        setupSubviews()
    }
    
    func setupBackground() {
        view.backgroundColor = .white
    }
    
    func setupSubviews() {
        view.addSubviews([labelImage, labelText, addToFavouritesButton])
        
        setupConstraints()
    }
    
    func setupConstraints() {
        labelImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        labelImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        labelImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        labelImage.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        labelText.topAnchor.constraint(equalToSystemSpacingBelow: labelImage.bottomAnchor, multiplier: 16).isActive = true
        labelText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        labelText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        labelText.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
        
        addToFavouritesButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60).isActive = true
        addToFavouritesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        addToFavouritesButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        addToFavouritesButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
}

private extension NewsDetailsViewController {
    @objc private func addToFavouritesAction() {
        viewModel.create(article: news)
    }
}
