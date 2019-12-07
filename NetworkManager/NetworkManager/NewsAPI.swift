//
//  NewsAPI.swift
//  NetworkManager
//
//  Created by Vetaliy Poltavets on 12/7/19.
//  Copyright © 2019 vpoltave. All rights reserved.
//

import Foundation

// TODO: Move somewhere else later
private let baseURL = "https://newsapi.org/v2"
private let apiKey = "0c38053a562747a4bff311490c1ad6be"

// TODO: Move somewhere else later
typealias Parameters = [String: Any]
typealias HTTPHeaders = [String: String]

enum NewsAPI {
    case everything(model: ArticleInput)
}

extension NewsAPI {
    var path: String {
        switch self {
        case .everything:
            return "/everything"
        }
    }
    
    var parameters: Parameters {
        switch self {
        case .everything(let model):
            return createParameters(model: model)
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .everything:
            return ["Content-Type": "application/json",
                    "Authorization": apiKey]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .everything:
            return .get
        }
    }
    
    var fullURL: URL {
        switch self {
        case .everything:
            return URL(string: baseURL)!.appendingPathComponent(path)
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
