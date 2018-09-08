//
//  APIResponse.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import Foundation

public typealias JSONDictionary = [String: Any]

public struct APIResponse<Value> {
    let statusCode: Int?
    let data: Value?
    let message: String?
    let timeInterval: TimeInterval?

    let responseHeaders: [AnyHashable: Any]?

    init(statusCode: Int?, data: Value?, responseHeaders: [AnyHashable: Any]?, message: String?, timeInterval:TimeInterval?) {
        self.statusCode = statusCode
        self.data = data
        self.responseHeaders = responseHeaders
        self.message = message
        self.timeInterval = timeInterval
    }
}
