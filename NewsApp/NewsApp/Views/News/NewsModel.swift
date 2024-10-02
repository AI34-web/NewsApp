//
//  NewsModel.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 22.07.2024.
//

import UIKit

// секции таблицы
enum NewsViewTableSection: CaseIterable {
    case newsOftheDaySection
    case importantNewsSection
    case newsFeedSection
}

// категории новостей
enum NewsCategory {
    case business
    case entertainment
    case general
    case health
    case science
    case sports
    case technology
}

// MARK: - Model
struct News: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    var image: UIImage? = nil
    
    private enum CodingKeys: String, CodingKey {
        case source, author, title, description, url, urlToImage, publishedAt, content
    }
}

struct Source: Codable {
    let id: String?
    let name: String
}
