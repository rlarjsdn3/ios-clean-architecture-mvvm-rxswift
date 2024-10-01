//
//  BaseViewController.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {
    
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    deinit {
        // log.verbose("DEINIT: \(self.className)")
    }
    
    
    // MARK: - Rx
    
    var disposeBag = DisposeBag()
    
}
