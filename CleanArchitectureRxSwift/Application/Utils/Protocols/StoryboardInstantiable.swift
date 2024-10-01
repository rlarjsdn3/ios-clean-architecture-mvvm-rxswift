//
//  StoryboardInstantiable.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import UIKit

public protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype T
    static var defaultFileName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> T
}

public extension StoryboardInstantiable where Self: UIViewController {
    
    static var defaultFileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }
    
    static func instantiateViewColntroller(_ bundle: Bundle? = nil) -> Self {
        let fileName = defaultFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        guard
            let vc = storyboard.instantiateInitialViewController() as? Self
        else {
            fatalError("Cannot instantiate inital view controller \(Self.self) from storyboard with name \(fileName)")
        }
        return vc
    }
    
}
