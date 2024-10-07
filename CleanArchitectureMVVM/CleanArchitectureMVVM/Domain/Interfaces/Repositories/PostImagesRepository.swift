//
//  PostImagesRepository.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 10/7/24.
//

import Foundation

protocol PostImagesRepository {
    func fetchImage(
        with imagePath: String,
        width: Int,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> (any Cancellable)?
}
