//
//  FetchRecentMovieQueriesUseCase.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 10/7/24.
//

import Foundation

// This is another option to create Use Case using more generic way
final class FetchRecentMovieQueriesUseCase: UseCase {
    
    struct ReqeustValue {
        let maxCount: Int
    }
    typealias ResultValue = (Result<[MovieQuery], Error>)
    
    private let requesetValue: ReqeustValue
    private let completion: (ResultValue) -> Void
    private let movieQueriesRepository: MoviesQueriesRepository
    
    init(
        requesetValue: ReqeustValue,
        completion: @escaping (ResultValue) -> Void,
        movieQueriesRepository: MoviesQueriesRepository
    ) {
        self.requesetValue = requesetValue
        self.completion = completion
        self.movieQueriesRepository = movieQueriesRepository
    }
    
    func start() -> (any Cancellable)? {
        
        movieQueriesRepository.fetchRecentsQueries(
            maxCount: requesetValue.maxCount,
            completion: completion
        )
        return nil
    }
    
}
