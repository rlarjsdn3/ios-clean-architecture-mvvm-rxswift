//
//  Todo.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import Foundation

struct Todo: Equatable, Identifiable {
    
    typealias Identifier = Int
    
    let id: Identifier
    let todo: String
    let completed: Bool
    let userId: Int
    
}

struct TodoPage: Equatable {
    
    let todos: [Todo]
    let total: Int
    
}
