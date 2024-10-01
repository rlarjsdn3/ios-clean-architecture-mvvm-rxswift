//
//  DetectInit.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import Foundation

class DetectDeInit: NSObject {
    
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()
    
    deinit {
        // log.verbose("DEINIT: \(self.className)")
    }
    
}
