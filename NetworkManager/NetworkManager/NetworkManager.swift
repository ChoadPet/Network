//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Vetaliy Poltavets on 12/7/19.
//  Copyright © 2019 vpoltave. All rights reserved.
//

import Foundation

final class NetworkManager {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Public API
    func requestNews(model: ArticleInput, completion: @escaping (ArticleOutput?) -> Void) {
        request(api: .everything(model: model)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                let articles = self.decodeData(data, ofType: ArticleOutput.self)
                completion(articles)
                print("Articles information: \(String(describing: articles))")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Private API
    private func request(api: NewsAPI, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlComponents = createURLComponents(withURL: api.fullURL, parameters: api.parameters)
        let urlRequest = createURLRequest(urlComponents.url!, method: api.method, headers: api.headers)
        
        createDataTask(with: urlRequest) { data, response, error in
            guard let data = data,                            // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                error == nil else {                           // was there no error, otherwise ...
                    return completion(.failure(error!))
            }
            completion(.success(data))
        }.resume()
    }
    
    private func decodeData<DecodableType: Decodable>(_ data: Data,
                                                      ofType type: DecodableType.Type,
                                                      dataDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601) -> DecodableType? {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dataDecodingStrategy
        let decodedData = try? decoder.decode(DecodableType.self, from: data)
        return decodedData
    }
    
    @discardableResult
    private func createDataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let dataTask = session.dataTask(with: request, completionHandler: completion)
        return dataTask
    }
    
    private func createURLRequest(_ url: URL, method: HTTPMethod, headers: [String: String]?) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for (headerField, value) in headers {
                request.setValue(value, forHTTPHeaderField: headerField)
            }
        }
        return request
    }
    
    private func createURLComponents(withURL url: URL, parameters: Parameters) -> URLComponents {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        components.queryItems = parameters.map { URLQueryItem(name: $0, value: "\($1)") }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return components
    }
}
