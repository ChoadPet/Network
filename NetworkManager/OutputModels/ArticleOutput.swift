//
//  ArticleOutput.swift
//  NetworkManager
//
//  Created by Vetaliy Poltavets on 12/7/19.
//  Copyright © 2019 vpoltave. All rights reserved.
//

import Foundation

struct ArticleOutput: Decodable {
    let status: String
    let totalResults: Int
    let articles: [NewsEntity]?
}

final class NewsSource: Decodable {
    let id: String?
    let name: String?
}

final class NewsEntity: Decodable {
    var articleID = UUID().uuidString
    var author: String?
    var content: String?
    var articleDescription: String?
    var publishedAt: String?
    var source: NewsSource?
    var title: String?
    var urlToImage: String?
    
    private enum CodingKeys: String, CodingKey {
        case author
        case content
        case articleDescription = "description"
        case publishedAt
        case source
        case title
        case urlToImage
    }
}
