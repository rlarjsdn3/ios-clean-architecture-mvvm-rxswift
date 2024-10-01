//
//  Networking.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import Foundation

import Moya
import RxMoya
import RxSwift

typealias TodoNetworking = Networking<TodoAPI>

final class Networking<Target: TargetType>: MoyaProvider<Target> {
    
    init(plugins: [any PluginType] = []) {
        let session = MoyaProvider<Target>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        super.init(session: session, plugins: plugins)
    }
    
    func request(
        _ target: Target,
        file: StaticString = #file,
        line: UInt = #line
    ) -> Single<Response> {
        let requestString = "\(target.method.rawValue) \(target.path)"
        return self.rx.request(target)
            .catchAPIError()
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { value in
                    let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                    // log.debug(message, file: file, function: function, line: line)
                },
                onError: { error in
                    if let response = (error as? MoyaError)?.response {
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                            // log.warning(message: file: file, function: function, line: line)
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                            // log.warning(message: file: file, function: function, line: line)
                        } else {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))"
                            // log.warning(message: file: file, function: function, line: line)
                        }
                    } else {
                        let message = "FAILURE: \(requestString)\n\(error)"
                        // log.warning(message: file: file, function: function, line: line)
                    }
                },
                onSubscribed: {
                    let message = "REQUEST: \(requestString)"
                    // log.debug(message, file: file, function: function, line: line)
                }
            )
    }
    
}
