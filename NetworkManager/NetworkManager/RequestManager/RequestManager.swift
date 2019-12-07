//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by Vetaliy Poltavets on 12/7/19.
//  Copyright © 2019 vpoltave. All rights reserved.
//

import Foundation

protocol RequestManagerProvider {
    
    associatedtype Api: ApiProvider
    
    func request(api: Api, completion: @escaping (Result<CustomResponse, Error>) -> Void)
}

final class RequestManager<Api: ApiProvider> {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    
    // MARK: - Private API
    @discardableResult
    private func createDataTask(with request: URLRequest,
                                completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request, completionHandler: completion)
    }
    
    private func createURLRequest(forAPI api: Api) -> URLRequest {
        var components = URLComponents(url: URL(api: api), resolvingAgainstBaseURL: false)!
        components.queryItems = api.parameters.map { URLQueryItem(name: $0, value: "\($1)") }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = api.method.rawValue
        
        for (headerField, value) in api.headers {
            request.setValue(value, forHTTPHeaderField: headerField)
        }
        return request
    }
}

extension RequestManager: RequestManagerProvider {
    
    func request(api: Api, completion: @escaping (Result<CustomResponse, Error>) -> Void) {
        let urlRequest = createURLRequest(forAPI: api)
        
        createDataTask(with: urlRequest) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else { return completion(.failure(error!)) }
            
            let customResponse = CustomResponse(statusCode: response.statusCode, data: data, response: response)
            completion(.success(customResponse))
        }.resume()
    }
}
