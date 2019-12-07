//
//  CustomResponse.swift
//  NetworkManager
//
//  Created by Vetaliy Poltavets on 12/7/19.
//  Copyright © 2019 vpoltave. All rights reserved.
//

import Foundation

final class CustomResponse {
    let statusCode: Int
    let data: Data
    let response: HTTPURLResponse?
    
    init(statusCode: Int, data: Data, response: HTTPURLResponse?) {
        self.statusCode = statusCode
        self.data = data
        self.response = response
    }
}
