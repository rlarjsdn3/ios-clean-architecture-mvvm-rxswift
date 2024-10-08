//
//  MoviesQueryRequestDTO+Mapping.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 10/7/24.
//

import Foundation

struct MoviesRequestDTO: Encodable {
    let query: String
    let page: Int
}
