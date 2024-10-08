//
//  MoviesResponseStorage.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 10/7/24.
//

import Foundation

protocol MoviesResponseStorage {
    func getResponse(
        for request: MoviesRequestDTO,
        completion: @escaping (Result<MoviesResponseDTO?, Error>) -> Void
    )
    func save(response: MoviesResponseDTO, for requestDto: MoviesRequestDTO)
}
