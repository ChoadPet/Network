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
    private func createDataTask(with request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request, completionHandler: completion)
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

extension RequestManager: RequestManagerProvider {
    
    func request(api: Api, completion: @escaping (Result<CustomResponse, Error>) -> Void) {
        let urlComponents = createURLComponents(withURL: URL(api: api), parameters: api.parameters)
        let urlRequest = createURLRequest(urlComponents.url!, method: api.method, headers: api.headers)
        
        // TODO: Remove validation to separate function
        createDataTask(with: urlRequest) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else { return completion(.failure(error!)) }
            
            let customResponse = CustomResponse(statusCode: response.statusCode, data: data, response: response)
            completion(.success(customResponse))
        }.resume()
    }
}
