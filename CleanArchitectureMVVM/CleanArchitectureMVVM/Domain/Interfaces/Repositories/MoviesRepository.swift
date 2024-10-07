//
//  MoviesRepository.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 10/7/24.
//

import Foundation

protocol MoviesRepository {
    @discardableResult
    func fetchMoviesList(
        query: MovieQuery,
        page: Int,
        cached: @escaping (MoviesPage) -> Void,
        completion: @escaping (Result<MoviesPage, Error>) -> Void
    ) -> (any Cancellable)?
}
