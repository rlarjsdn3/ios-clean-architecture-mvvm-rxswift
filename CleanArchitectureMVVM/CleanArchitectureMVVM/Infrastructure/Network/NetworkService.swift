//
//  NetworkService.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 10/5/24.
//

import Foundation

enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }

protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: any Requestable, completion: @escaping CompletionHandler) -> (any NetworkCancellable)?
}

protocol NetworkSessionManager {
    typealias CompletionHandler = (Data?, URLResponse?, (any Error)?) -> Void
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable
}

protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

// MARK: - Implementation

final class DefaultNetworkService {
    
    private let config: any NetworkConfigurable
    private let sessionManager: any NetworkSessionManager
    private let logger: any NetworkErrorLogger
    
    init(
        config: any NetworkConfigurable,
        sessionManager: any NetworkSessionManager = DefaultNetworkSession(),
        logger: any NetworkErrorLogger = DefaultNetworkErrorLogger()
    ) {
        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }
    
    private func request(
        request: URLRequest,
        compeletion: @escaping CompletionHandler
    ) -> NetworkCancellable {
        
        let sessionDataTask = sessionManager.request(request) { data, response, requestError in
            
            if let requestError = requestError {
                var error: NetworkError
                if let response = response as? HTTPURLResponse {
                    error = .error(statusCode: response.statusCode, data: data)
                } else {
                    error = self.resolve(error: requestError)
                }
                
                self.logger.log(error: requestError)
                compeletion(.failure(error))
            } else {
                self.logger.log(responseData: data, response: response)
                compeletion(.success(data))
            }
            
        }
        
        logger.log(request: request)
        
        return sessionDataTask
        
    }
    
    private func resolve(error: any Error) -> NetworkError {
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet: return .notConnected
        case .cancelled: return .cancelled
        default: return .generic(error)
        }
    }
    
}

extension DefaultNetworkService: NetworkService {
    
    func request(
        endpoint: any Requestable,
        completion: @escaping CompletionHandler
    ) -> (any NetworkCancellable)? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, compeletion: completion)
        } catch {
            completion(.failure(.urlGeneration))
            return nil
        }
    }
    
}



// MARK: - Default Network Session Manager
// Note: If authorization is needed NetworkSessionManager can be implemented by using,
// for example, Alamofire SessionManager with its RequestAdapter and RequestRetrier.
// And it can be injected into NetworkService instead of default one.

final class DefaultNetworkSession: NetworkSessionManager {
    func request(
        _ request: URLRequest,
        completion: @escaping CompletionHandler
    ) -> any NetworkCancellable {
        let task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        task.resume()
        return task
    }
}

// MARK: - Logger

final class DefaultNetworkErrorLogger: NetworkErrorLogger {
    init() { }
    
    func log(request: URLRequest) {
        print("-------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = (try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) {
            printIfDebug("body: \(String(describing: result))")
        } else if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            printIfDebug("body: \(String(describing: resultString))")
        }
    }
    
    func log(responseData data: Data?, response: URLResponse?) {
        guard let data = data else { return }
        if let dataDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            printIfDebug("responseData: \(String(describing: dataDict))")
        }
    }
    
    func log(error: any Error) {
        printIfDebug("\(error)")
    }

}

// MARK: - NetworkError Extension

extension NetworkError {
    var isNotFoundError: Bool { return hasStatusCode(404) }
    
    func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case let .error(code, _):
            return code == codeError
        default:
            return false
        }
    }
}

extension Dictionary where Key == String {
    func prettyPrint() -> String {
        var string: String = ""
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            if let str = String(data: data, encoding: .utf8) {
                string = str
            }
        }
        return string
    }
}


func printIfDebug(_ string: String) {
    #if DEBUG
    print(string)
    #endif
}
