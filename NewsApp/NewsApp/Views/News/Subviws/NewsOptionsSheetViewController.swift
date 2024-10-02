//
//  NewsOptionsSheetViewController.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 05.09.2024.
//

import UIKit

class NewsOptionsSheetViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // configure view
    private func configure() {
        setupConstraints()
        background()
    }
    
    // MARK: - UIElements
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Options"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}

// MARK: - Constraints
extension NewsOptionsSheetViewController {
    private func setupConstraints() {
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

// MARK: - View consfigurations
extension NewsOptionsSheetViewController {
    private func background() {
        view.backgroundColor = .white
    }
}
