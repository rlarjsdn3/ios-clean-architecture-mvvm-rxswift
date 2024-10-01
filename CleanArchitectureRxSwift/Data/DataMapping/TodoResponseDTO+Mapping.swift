//
//  TodoDTO+Mapping.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import Foundation


//{
//  "todos": [
//    {
//      "id": 1,
//      "todo": "Do something nice for someone I care about",
//      "completed": true,
//      "userId": 26
//    },
//    {...},
//    {...}
//    // 30 items
//  ],
//  "total": 150,
//  "skip": 0,
//  "limit": 30
//}

// MARK: - Data Transfer Object

struct TodoResponseDTO: ModelType {
    private enum CodingKeys: String, CodingKey {
        case todos
        case total
        case skip
        case limit
    }
    let todos: [TodoDTO]
    let total: Int
    let skip: Int
    let limit: Int
}

extension TodoResponseDTO {
    struct TodoDTO: ModelType {
        private enum CodingKeys: String, CodingKey {
            case id
            case todo
            case completed
            case userId
        }
        let id: Int
        let todo: String
        let completed: Bool
        let userId: Int
    }
}


// MARK: - Mapping to Domain

extension TodoResponseDTO {
    func toDomain() -> TodoPage {
        return .init(
            todos: todos.map { $0.toDomain() },
            total: total
        )
    }
}

extension TodoResponseDTO.TodoDTO {
    func toDomain() -> Todo {
        return .init(
            id: id,
            todo: todo,
            completed: completed,
            userId: userId
        )
    }
}
