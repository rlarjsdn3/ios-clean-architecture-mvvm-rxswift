//
//  ModelType.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import Foundation

import Then

protocol ModelType: Codable, Then {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension ModelType {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        return .iso8601
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = dateDecodingStrategy
        return decoder
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard
            let dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any]
        else { throw NSError() }
        return dictionary
    }
}
