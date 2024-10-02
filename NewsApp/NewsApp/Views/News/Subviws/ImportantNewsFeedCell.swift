//
//  ImportantNewsFeedCell.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 31.08.2024.
//

import UIKit

/// Лента важных новостей
final class ImportantNewsFeedCell: UITableViewCell {
    static let identifier = "ImportantNewsFeedCell"
    
    // MARK: Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collection.dataSource = self
        collection.delegate = self
        
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
        contentView.addSubview(collection)
    }
    
    private func setupConstraints() {
        
        // коллекция
        collection.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        collection.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        collection.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        collection.heightAnchor.constraint(equalToConstant: 150.0).isActive = true
    }
    
    // MARK: UIElements
    private var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(ImportantNewsCell.self, forCellWithReuseIdentifier: ImportantNewsCell.identifire)
        
        return collection
    }()
}

extension ImportantNewsFeedCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImportantNewsCell.identifire, for: indexPath) as! ImportantNewsCell
//        cell.contentView.backgroundColor = .blue
//        cell.layer.cornerRadius = 10
//        cell.layer.masksToBounds = true
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 200.0, height: 150.0)
//    }
}

final class ImportantNewsCell: UICollectionViewCell {
    static let identifire = "ImportantNewsCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupSubviews() {
        contentView.addSubview(image)
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        
        image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
    }
    
    private var image: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(resource: .test)
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
}
