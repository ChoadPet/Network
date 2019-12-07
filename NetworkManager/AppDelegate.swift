//
//  AppDelegate.swift
//  NetworkManager
//
//  Created by Vetaliy Poltavets on 12/6/19.
//  Copyright © 2019 vpoltave. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var networkManager: NetworkManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let requestManager = RequestManager<NewsAPI>()
        networkManager = NetworkManager(requestManager: requestManager)
        
        let model1 = ArticleInput(pageSize: 5, page: 1, language: "en", keywordsOrPhrase: "dogs")
        networkManager.provideEverythingNews(model: model1) { result in
            print(result ?? "No articles getting")
        }
        
        let model2 = ArticleInput(pageSize: 10, page: 1, language: "en", keywordsOrPhrase: "apple")
        networkManager.provideTopHeadlinesNews(model: model2) { result in
            print(result ?? "No articles getting")
        }
        
        return true
    }



}

