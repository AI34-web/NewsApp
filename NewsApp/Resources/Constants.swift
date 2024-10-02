//
//  Constants.swift
//  PhantomLiberty
//
//  Created by Artyom Ivanov on 22.07.2024.
//

import Foundation

enum Constants {
    
    // TODO: - удалить позже
    static let constantsAPIKey = "b6ba64052fbb4942afc88219984a9c72"
    static let requestEverything = "https://newsapi.org/v2/everything?q=bitcoin&apiKey=b6ba64052fbb4942afc88219984a9c72"
    static let requestTopHeadlines = "https://newsapi.org/v2/top-headlines/sources?apiKey=b6ba64052fbb4942afc88219984a9c72"
    static let requestTopHeadlinesTech = "https://newsapi.org/v2/top-headlines/sources?category=technologyapiKey=b6ba64052fbb4942afc88219984a9c72"
    
    // нужно устанавливать как квери параметр
    static let requestJustBusiness = "https://newsapi.org/v2/top-headlines/sources?category=businessapiKey=b6ba64052fbb4942afc88219984a9c72"
    /*
     хост: https://newsapi.org
     
     */
    
    enum TabBar {
        static func title(for tab: Tabs) -> String {
            switch tab {
            case .overview: return "Overview"
            case .session: return "Session"
            case .progress: return "Progress"
            case .settings: return "Settings"
            }
        }
    }
}
