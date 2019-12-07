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
        
        networkManager = NetworkManager()
        
        let model = ArticleInput(pageSize: 5, page: 1, language: "en", keywordsOrPhrase: "dogs")
        networkManager.requestNews(model: model) { response in
            
        }
        
        return true
    }



}

