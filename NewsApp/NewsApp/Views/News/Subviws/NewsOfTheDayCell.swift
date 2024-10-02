//
//  NewsOfTheDayCell.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 15.08.2024.
//

import UIKit
import RxSwift

// MARK: - NewsOfTheDayCell
/// Новость дня
final class NewsOfTheDayCell: UITableViewCell {
    
    // MARK: Properties
    static let identifier = "NewsOfTheDayCell"
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
        
        // TODO: - Remove
        contentView.backgroundColor = .blue
        addSubviews()
    }
    
    private func addSubviews() {
        contentView.addSubview(imageTitle)
        imageTitle.addSubview(title)
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        imageTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16).isActive = true
        imageTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        imageTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        imageTitle.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        title.bottomAnchor.constraint(equalTo: imageTitle.bottomAnchor, constant: -8).isActive = true
        title.leadingAnchor.constraint(equalTo: imageTitle.leadingAnchor, constant: 8).isActive = true
        title.trailingAnchor.constraint(equalTo: imageTitle.trailingAnchor).isActive = true
    }
    
    // MARK: UIElements
    private var imageTitle: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        let cornerRadius = min(view.bounds.width, view.bounds.height) / 2
        view.layer.cornerRadius = cornerRadius
        
        return view
    }()
    
    // текст должен быть поверх картинки(вью должна быть на вью картинки)
    private var title:  UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // configure
    func configurationImage(from urlToImage: String, index: Int) {
        if let image = news?.image {
            self.imageTitle.image = image
        } else {
            
            // реализацию этого кода можно вынести в отдельный модуль
            if let viewModel = viewModel,
               let url = URL(string: urlToImage) {
                viewModel.downloadImage(from: url)
                    .observe(on: MainScheduler.instance)
                    .subscribe(onNext: { [weak self] image in
                        guard let self, let image else {
                            self?.imageTitle.image = UIImage(resource: .test)
                            return
                        }
                        
                        self.imageTitle.image = image
                        viewModel.updateArticleImage(at: index, with: image)
                    })
                    .disposed(by: viewModel.disposeBag)
            }
        }
        
    }
    
    func configurationLabel(text: String) {
        self.title.text = text
    }
    
    func setDefaultImage() {
        self.imageTitle.image = UIImage(resource: .test)
    }
}
