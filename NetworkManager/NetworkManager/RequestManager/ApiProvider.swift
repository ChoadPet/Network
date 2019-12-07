//
//  ApiProvider.swift
//  NetworkManager
//
//  Created by Vetaliy Poltavets on 12/7/19.
//  Copyright © 2019 vpoltave. All rights reserved.
//

import Foundation

protocol ApiProvider {
    var baseURL: URL { get }
    var path: String { get }
    var parameters: Parameters { get }
    var headers: [String: String] { get }
    var method: HTTPMethod { get }
}
