//
//  NewsViewModel.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 22.07.2024.
//

import UIKit
import RxSwift
import RxCocoa

class NewsViewModel {
    private let newsManager: NewsManagerProtocol
    private let newsRealmManager: NewsRealmManagerProtocol
    var newsSubject: BehaviorSubject<[Article]>
    let disposeBag = DisposeBag()
    
    init(newsManager: NewsManagerProtocol, newsRealmManager: NewsRealmManagerProtocol) {
        self.newsManager = newsManager
        self.newsRealmManager = newsRealmManager
        self.newsSubject = BehaviorSubject(value: [])
        self.newsManager.newsArticles
            .bind(to: newsSubject)
            .disposed(by: disposeBag)
    }
    
    func fetchNews() {
        newsManager.fetchMainNews()
    }
    
    func downloadImage(from url: URL) -> Observable<UIImage?> {
        print("сработала функция загрузки изображения")
        return Observable.create { observer in
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                    let error = NSError(domain: "Invalid HTTP response", code: httpResponse.statusCode, userInfo: nil)
                    observer.onError(error)
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    observer.onNext(image)
                    observer.onCompleted()
                } else {
                    observer.onError(NSError(domain: "Image parsing error", code: -1, userInfo: nil))
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        .share(replay: 1, scope: .forever) // Переиспользование активных запросов
    }
    
    func updateArticleImage(at index: Int, with image: UIImage) {
        do {
            var articles = try newsSubject.value()
            articles[index].image = image
            newsSubject.onNext(articles)
        } catch {
            print("Ошибка при обновлении статьи: \(error)")
        }
    }
    
    // MARK: CRUD
    func create(article: Article) {
        newsRealmManager.saveNews(article)
    }
    
    func read() {
        
    }
    
    func update() {
        
    }
    
    func delete() {
        
    }
}
