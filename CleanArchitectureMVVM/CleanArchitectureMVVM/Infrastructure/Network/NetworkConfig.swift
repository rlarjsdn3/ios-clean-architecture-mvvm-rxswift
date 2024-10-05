//
//  NetworkConfig.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 10/5/24.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {
    var baseURL: URL
    var headers: [String: String]
    var queryParameters: [String: String]
    
    init(
        baseURL: URL,
        headers: [String: String] = [:],
        queryParameters: [String: String] = [:]
    ) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParameters = queryParameters
    }
}
