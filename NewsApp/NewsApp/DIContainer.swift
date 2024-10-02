//
//  DIContainer.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 27.09.2024.
//

import UIKit

final class DIContainer {
    static let shared = DIContainer()

    private init() {}

    // В DI-контейнере хранится один экземпляр NetworkDataController
    private let networkDataController: NetworkDataControllerProtocol = NetworkDataController()
//    private let newsRealmManager: NewsRealmManager = NewsRealmManager()
    
    func makeNewsManager() -> NewsManagerProtocol {
        return NewsManager(networkDataController: networkDataController)
    }
    
    func makeNewsNewsRealmManager() -> NewsRealmManager{
        return NewsRealmManager()
    }
}
