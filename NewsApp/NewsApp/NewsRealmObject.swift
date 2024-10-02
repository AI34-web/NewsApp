//
//  NewsRealmObject.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 01.10.2024.
//

import UIKit
import RealmSwift

class NewsRealmObject: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var image: Data?
    @Persisted var title: String
    @Persisted var newsDescription: String?
}

protocol NewsRealmManagerProtocol {
    func saveNews(_ article: Article)
    func getNews() -> [NewsRealmObject]
    func deleteNews(_ article: NewsRealmObject)
}

final class NewsRealmManager: NewsRealmManagerProtocol {
    private let realm = try! Realm()
    
    func saveNews(_ article: Article) {
        let newsObject = NewsRealmObject()
        newsObject.newsDescription = article.description
        newsObject.title = article.title
        if let image = article.image,
           let data = image.jpegData(compressionQuality: 1.0) {
            newsObject.image = data
        }
        
        do {
            try realm.write {
                realm.add(newsObject, update: .modified)
            }
        } catch {
            print("Ошибка при сохранении новости: \(error)")
        }
    }
    
    func getNews() -> [NewsRealmObject] {
        let news = realm.objects(NewsRealmObject.self)
        return Array(news)
    }
    
    func deleteNews(_ article: NewsRealmObject) {
        do {
            try realm.write {
                realm.delete(article)
            }
        } catch {
            print("Ошибка при удалении новости: \(error)")
        }
    }
}

