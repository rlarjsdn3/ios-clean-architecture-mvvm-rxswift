//
//  ViewModelType.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
