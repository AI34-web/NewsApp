//
//  NewsManager.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 05.09.2024.
//

import Foundation
import RxSwift
import RxCocoa

protocol NewsManagerProtocol {
    var newsArticles: BehaviorRelay<[Article]> { get }
    func fetchMainNews()
}

class NewsManager: NewsManagerProtocol {
    private let disposeBag = DisposeBag()
    private let networkDataController: NetworkDataControllerProtocol
    
    var newsArticles = BehaviorRelay<[Article]>(value: [])
    
    init(networkDataController: NetworkDataControllerProtocol) {
        self.networkDataController = networkDataController
    }
    
    func fetchMainNews() {
        networkDataController.publisher(request: AllNews.MainNews(country: "us"))
            .catch { Single.error($0) }
        
        // может быть стоит получать только артикли новостей
            .map { (news: News) in news }
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] news in
                guard let self else { return }
                self.newsArticles.accept(news.articles)
            }, onFailure: { error in
                
                // можно выводить ошибку получения новостей
            })
            .disposed(by: disposeBag)
    }
}
