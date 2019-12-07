//
//  URLExtension.swift
//  NetworkManager
//
//  Created by Vetaliy Poltavets on 12/7/19.
//  Copyright © 2019 vpoltave. All rights reserved.
//

import Foundation

extension URL {
    
    init(api: ApiProvider) {
        self = api.baseURL.appendingPathComponent(api.path)
    }
}
