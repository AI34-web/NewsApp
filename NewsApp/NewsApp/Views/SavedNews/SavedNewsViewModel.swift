//
//  SavedNewsViewMode.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 01.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SavedNewsViewModel {
    private let newsRealmManager: NewsRealmManagerProtocol
    
    var savedNewsSubject: BehaviorSubject<[NewsRealmObject]> = BehaviorSubject(value: [])
    
    init(newsRealmManager: NewsRealmManagerProtocol) {
        self.newsRealmManager = newsRealmManager
    }
    
    func getSavedNews() {
        let savedNews = newsRealmManager.getNews()
        savedNewsSubject.onNext(savedNews)
    }
    
    func deleteNews(news: NewsRealmObject) {
        newsRealmManager.deleteNews(news)
        getSavedNews()
    }
}
