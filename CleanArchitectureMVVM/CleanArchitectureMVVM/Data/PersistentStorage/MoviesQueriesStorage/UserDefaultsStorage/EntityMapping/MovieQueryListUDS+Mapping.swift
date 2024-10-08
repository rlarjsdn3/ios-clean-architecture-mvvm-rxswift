//
//  File.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 10/7/24.
//

import Foundation

struct MovieQueriesListUDS: Codable {
    var list: [MovieQueryUDS]
}

struct MovieQueryUDS: Codable {
    let query: String
}

extension MovieQueryUDS {
    init(movieQuery: MovieQuery) {
        query = movieQuery.query
    }
}

extension MovieQueryUDS {
    func toDomain() -> MovieQuery {
        return .init(query: query)
    }
}
