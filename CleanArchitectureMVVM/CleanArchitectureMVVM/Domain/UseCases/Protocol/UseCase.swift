//
//  UseCase.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 10/7/24.
//

import Foundation

protocol UseCase {
    @discardableResult
    func start() -> (any Cancellable)?
}
