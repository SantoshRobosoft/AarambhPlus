//
//  APIError.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/8/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//
import Foundation

public enum APIError: Error {
    case noInternetConnection
    case invalidAccessToken
    case sessionExpired
    case invalidRequest
    case invalidResponse
    case parsingError
    case somethingWentWrong
    case needRetry
    case generalError(code: Int?, message: String?)
    case accountBlocked(message:String?)
    case loginFailed(message:String?)

    func localizedDescription() -> String {
        switch self {
        case .noInternetConnection:
            return "Sorry we are unable to connect to internet now. please check your network connection"
        case .invalidRequest:
            return "Problem with network request. please try later"
        case .parsingError:
            return "Unable to parse the server response. please try later"
        case .somethingWentWrong:
            return "Something went wrong. please try later"
        case .generalError(_, let message):
            return message ?? "Something went wrong. please try later"
        case .accountBlocked(let message):
            return message ?? "Something went wrong. please try later"
        case .loginFailed(let message):
            return message ?? "Login failed."
        default:
            return "Something went wrong. please try later"
        }
    }
}

public enum SSLError: Int {
    case secureConnectionFailed = -1200
    case certificateHasBadDate = -1201
    case certificateUntrusted = -1202
    case certificateWithUnkownRoot = -1203
    case cerificateNotYetValid = -1204
    case certificateRejected = -1205
    case certificateRequired = -1206
    case unableToLoadFromNetwork = -2000
}
