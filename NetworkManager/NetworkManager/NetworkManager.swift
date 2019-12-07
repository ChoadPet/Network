//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Vetaliy Poltavets on 12/7/19.
//  Copyright © 2019 vpoltave. All rights reserved.
//

import Foundation

typealias Parameters = [String: Any]

enum HTTPMethod: String {
    case get
    case post
}

final class NetworkManager {
    
    private let fullPath = "https://newsapi.org/v2/everything"
    private let apiKey = "0c38053a562747a4bff311490c1ad6be"
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    // MARK: - Public API
    func requestNews(model: ArticleInput, completion: @escaping (ArticleOutput?) -> Void) {
        
        let urlComponents = createURLComponents(stringURL: fullPath, items: model)
        let urlRequest = createURLRequest(urlComponents.url!,
                                          method: .get,
                                          headers: ["Content-Type": "application/json", "Authorization": apiKey])
        
        createDataTask(with: urlRequest) { data, response, error in
            guard let data = data,                            // is there data
                let response = response as? HTTPURLResponse,  // is there HTTP response
                (200 ..< 300) ~= response.statusCode,         // is statusCode 2XX
                error == nil else {                           // was there no error, otherwise ...
                    return completion(nil)
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let articles = try? decoder.decode(ArticleOutput.self, from: data)
            completion(articles)
            print(articles)
        }.resume()
    }
    
    // MARK: - Private API
    @discardableResult
    private func createDataTask(with request: URLRequest,
                                completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
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
    
    private func createURLComponents<ObjectType: Encodable>(stringURL: String, items: ObjectType) -> URLComponents {
        var components = URLComponents(string: stringURL)!
        components.queryItems = createParameters(model: items).map { URLQueryItem(name: $0, value: "\($1)") }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return components
    }
    
    private func createParameters<ObjectType: Encodable>(model: ObjectType) -> Parameters {
        let data = try! JSONEncoder().encode(model)
        let parameters = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! Parameters
        return parameters
    }
}
