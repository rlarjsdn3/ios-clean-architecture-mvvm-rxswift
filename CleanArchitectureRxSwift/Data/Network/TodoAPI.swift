//
//  TodoDAO.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import Foundation

import Moya
import RxSwift

enum TodoAPI {
    case todos
}

extension TodoAPI: TargetType {
    
    var baseURL: URL {
        URL(string: "https://dummyjson.com/")!
    }
    
    var path: String {
        switch self {
        case .todos: return "todos"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .todos: return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .todos: return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
}
