//
//  ErrorTracker.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import Foundation

import RxCocoa
import RxSwift

final class ErrorTracker: SharedSequenceConvertibleType {
    
    typealias Element = Error
    typealias SharingStrategy = DriverSharingStrategy
    
    private let _subject = PublishSubject<Error>()
    
    func trackError<O: ObservableConvertibleType>(from source: O) -> Observable<O.Element> {
        return source.asObservable().do(onError: onError)
    }
    
    func asSharedSequence() -> SharedSequence<SharingStrategy, Element> {
        return _subject.asObserver().asDriverOnErrorJustComplete()
    }
    
    func asObservable() -> Observable<Element> {
        return _subject.asObservable()
    }
    
    private func onError(_ error: any Element) {
        _subject.onNext(error)
    }
    
    deinit {
        _subject.onCompleted()
    }
    
}

extension ObservableConvertibleType {
    
    func trackError(_ errorTracker: ErrorTracker) -> Observable<Element> {
        return errorTracker.trackError(from: self)
    }
    
}
