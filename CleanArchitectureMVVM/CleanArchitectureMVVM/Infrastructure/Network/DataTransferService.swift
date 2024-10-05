//
//  DataTransferService.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 10/5/24.
//

import Foundation

enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkError(Error)
}

protocol DataTransferDispatchQueue {
    func asyncExecute(work: @escaping @Sendable () -> Void)
}

extension DispatchQueue: DataTransferDispatchQueue {
    func asyncExecute(work: @escaping @Sendable () -> Void) {
        async(group: nil, execute: work)
    }
}

protocol DataTransferService {
    typealias CompletionHandler<T> = (Result<T, DataTransferError>) -> Void
    
    @discardableResult
    func request<T, E>(
        with endpoint: E,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<T>
    ) -> (any NetworkCancellable)? where T: Decodable, E: ResponseRequestable, E.Response == T
    
    @discardableResult
    func request<T, E>(
        with endpoint: E,
        completion: @escaping CompletionHandler<T>
    ) -> (any NetworkCancellable)? where T: Decodable, E: ResponseRequestable, E.Response == T
    
    @discardableResult
    func request<E>(
        with endpoint: E,
        on queue: DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<Void>
    ) -> (any NetworkCancellable)? where E: ResponseRequestable, E.Response == Void
    
    @discardableResult
    func request<E>(
        with endpoint: E,
        completion: @escaping CompletionHandler<Void>
    ) -> (any NetworkCancellable)? where E: ResponseRequestable, E.Response == Void
}

protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

protocol ResponseDecoder {
    func decode<T>(_ data: Data) throws -> T where T: Decodable
}

protocol DataTransferErrorLogger {
    func log(error: any Error)
}

final class DefaultDataTransferService {
    
    private let networkService: any NetworkService
    private let errorResolver: any DataTransferErrorResolver
    private let errorLogger: any DataTransferErrorLogger
    
    init(
        with networkService: any NetworkService,
        errorResolver: any DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
        errorLogger: any DataTransferErrorLogger = DefaultDataTransferErrorLogger()
    ) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
    
}

extension DefaultDataTransferService: DataTransferService {
    
    func request<T, E>(
        with endpoint: E,
        on queue: any DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<T>
    ) -> (any NetworkCancellable)? where T: Decodable, T == E.Response, E: ResponseRequestable {
        
        networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                let result: Result<T, DataTransferError> = self.decode(
                    data: data,
                    decoder: endpoint.responseDecoder
                )
                queue.asyncExecute { completion(result) }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                queue.asyncExecute { completion(.failure(error)) }
            }
        }
        
    }
    
    func request<T, E>(
        with endpoint: E,
        completion: @escaping CompletionHandler<T>
    ) -> (any NetworkCancellable)? where T: Decodable, T == E.Response, E: ResponseRequestable {
        
        request(with: endpoint, on: DispatchQueue.main, completion: completion)
        
    }
    
    func request<E>(
        with endpoint: E,
        on queue: any DataTransferDispatchQueue,
        completion: @escaping CompletionHandler<Void>
    ) -> (any NetworkCancellable)? where E : ResponseRequestable, E.Response == () {
        
        networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success:
                queue.asyncExecute { completion(.success(())) }
            case .failure(let error):
                self.errorLogger.log(error: error)
                let error = self.resolve(networkError: error)
                queue.asyncExecute { completion(.failure(error)) }
            }
        }
        
    }
    
    func request<E>(
        with endpoint: E,
        completion: @escaping CompletionHandler<Void>
    ) -> (any NetworkCancellable)? where E : ResponseRequestable, E.Response == () {
        
        request(with: endpoint, on: DispatchQueue.main, completion: completion)
        
    }
    
    
    
    // MARK: - Private
    private func decode<T>(
        data: Data?,
        decoder: any ResponseDecoder
    ) -> Result<T, DataTransferError> where T: Decodable {
        do {
            guard let data = data else { return .failure(.noResponse) }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            self.errorLogger.log(error: error)
            return .failure(.parsing(error))
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError
        ? .networkFailure(error)
        : .resolvedNetworkError(resolvedError)
    }
    
}



// MARK: - Logger

final class DefaultDataTransferErrorLogger: DataTransferErrorLogger {
    init() { }
    
    func log(error: any Error) {
        printIfDebug("-------------")
        printIfDebug("\(error)")
    }
}

// MARK: - Error Resolver

class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    init() { }
    func resolve(error: NetworkError) -> any Error {
        return error
    }
}

// MARK: - Response Decoders

class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    init() { }
    func decode<T>(_ data: Data) throws -> T where T: Decodable {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

class RawDataResponseDecoder: ResponseDecoder {
    init() { }
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    func decode<T>(_ data: Data) throws -> T where T : Decodable {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(
                codingPath: [CodingKeys.default],
                debugDescription: "Expected Data type"
            )
            throw DecodingError.typeMismatch(T.self, context)
        }
    }
}
