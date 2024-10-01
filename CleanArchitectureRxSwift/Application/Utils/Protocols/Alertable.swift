//
//  Alertable.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import UIKit

public protocol Alertable { }

public extension Alertable where Self: UIViewController {
    
    func showAlert(
        title: String = "",
        message: String,
        preferredStyle: UIAlertController.Style = .alert,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
    
}
