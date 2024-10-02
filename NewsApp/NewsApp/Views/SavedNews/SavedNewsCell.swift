//
//  SavedNewsCell.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 01.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SavedNewsCell: UITableViewCell {
    static let identifier = "SavedNewsCell"
    let disposeBag = DisposeBag()
    var viewModel: SavedNewsViewModel?
    var news: NewsRealmObject?
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Error")
    }
    
    // MARK: Helpers
    private func configure() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        contentView.addSubviews([image, text, deleteNews])
    }
    
    private func setupConstraints() {
        image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        image.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        text.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        text.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        text.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 4).isActive = true
        text.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8).isActive = true
        
        deleteNews.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        deleteNews.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        deleteNews.heightAnchor.constraint(equalToConstant: 60).isActive = true
        deleteNews.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    // MARK: UIElements
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.image = UIImage(resource: .test)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var text:  UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .green
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var deleteNews: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(deleteNewsAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

private extension SavedNewsCell {
    @objc private func deleteNewsAction() {
        guard let news else { return }
        viewModel?.deleteNews(news: news)
    }
}

extension SavedNewsCell {
    func configureImage(image: Data) {
        self.image.image = UIImage(data: image)
    }
    
    func configureText(text: String) {
        self.text.text = text
    }
}
