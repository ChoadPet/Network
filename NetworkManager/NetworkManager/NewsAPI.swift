//
//  NewsAPI.swift
//  NetworkManager
//
//  Created by Vetaliy Poltavets on 12/7/19.
//  Copyright © 2019 vpoltave. All rights reserved.
//

import Foundation

// TODO: Move somewhere else later
private let apiKey = "0c38053a562747a4bff311490c1ad6be"

typealias Parameters = [String: Any]

enum NewsAPI {
    
    case everything(model: ArticleInput)
    case topHeadlines(model: ArticleInput)
}

extension NewsAPI: ApiProvider {
    
    var baseURL: URL {
        return URL(string: "https://newsapi.org/v2")!
    }
    
    var path: String {
        switch self {
        case .everything:
            return "/everything"
        case .topHeadlines:
            return "/top-headlines"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .everything(let model), .topHeadlines(let model):
            return createParameters(model: model)
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .everything, .topHeadlines:
            return ["Content-Type": "application/json",
                    "Authorization": apiKey]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .everything, .topHeadlines:
            return .get
        }
    }
}

private extension NewsAPI {
    private func createParameters<ObjectType: Encodable>(model: ObjectType) -> Parameters {
        let data = try! JSONEncoder().encode(model)
        let parameters = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Parameters
        return parameters
    }
}
