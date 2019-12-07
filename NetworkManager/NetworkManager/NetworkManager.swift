//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Vetaliy Poltavets on 12/7/19.
//  Copyright © 2019 vpoltave. All rights reserved.
//

import Foundation

final class NetworkManager {
    
    private let requestManager: RequestManager<NewsAPI>
    
    init(requestManager: RequestManager<NewsAPI>) {
        self.requestManager = requestManager
    }
    
    // MARK: - Public API
    func provideEverythingNews(model: ArticleInput, completion: @escaping (ArticleOutput?) -> Void) {
        requestManager.request(api: .everything(model: model)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let articles = try? self.decodeData(response.data, ofType: ArticleOutput.self)
                completion(articles)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func provideTopHeadlinesNews(model: ArticleInput, completion: @escaping (ArticleOutput?) -> Void) {
        requestManager.request(api: .topHeadlines(model: model)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                let articles = try? self.decodeData(response.data, ofType: ArticleOutput.self)
                completion(articles)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Private API
    private func decodeData<DecodableType: Decodable>(_ data: Data, ofType type: DecodableType.Type) throws -> DecodableType? {
        let decodedData = try JSONDecoder().decode(DecodableType.self, from: data)
        return decodedData
    }
}
