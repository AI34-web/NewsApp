//
//  NewsFeedCell.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 31.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

/// Лента важных новостей
final class NewsFeedCell: UITableViewCell {
    static let identifier = "NewsFeedCell"
    let disposeBag = DisposeBag()
    var viewModel: NewsViewModel?
    var news: Article?
    
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
        contentView.addSubviews([image, text])
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
    }
    
    // MARK: UIElements
    private var image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var text:  UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .green
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
}

extension NewsFeedCell {
    func configurationImage(from urlToImage: String, index: Int) {
        if let image = news?.image {
            self.image.image = image
        } else {
            
            // реализацию этого кода можно вынести в отдельный модуль
            if let viewModel = viewModel,
               let url = URL(string: urlToImage) {
                viewModel.downloadImage(from: url)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] image in
                        guard let self, let image else {
                            self?.image.image = UIImage(resource: .test)
                            return
                        }
                        
                        self.image.image = image
                        viewModel.updateArticleImage(at: index, with: image)
                    })
                    .disposed(by: viewModel.disposeBag)
            }
        }
    }
    
    func configurationLabel(text: String) {
        self.text.text = text
    }
}
