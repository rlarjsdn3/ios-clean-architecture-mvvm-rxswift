//
//  ApiError.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import Foundation

import Moya
import RxSwift

enum APIError: Error {
    
    case apiKeyExpired
    
    case with(statusCode: Int, message: String)
    
    init(statusCode: Int, message: String) {
        switch statusCode {
        case 500:
            self = .apiKeyExpired
        default:
            self = .with(statusCode: statusCode, message: message)
        }
    }
    
}

extension APIError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .apiKeyExpired:
            return NSLocalizedString("The API key has expired. Please contact the developer.", comment: "")
        case let .with(statusCode, message):
            return NSLocalizedString(message, comment: "")
        }
    }
    
}

extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
    
    func catchAPIError() -> Single<Element> {
        return flatMap { response in
            guard (200..<300).contains(response.statusCode) else {
                throw APIError(
                    statusCode: response.statusCode,
                    message: "The API responses with status code \(response.statusCode)"
                )
            }
            
            return .just(response)
        }
    }
    
}
