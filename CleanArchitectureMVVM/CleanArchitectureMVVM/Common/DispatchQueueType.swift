//
//  DispatchQueueTyope.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 10/7/24.
//

import Foundation

/// Used to easily mock main and background queues in tests
protocol DispatchQueueType {
    func async(execute work: @escaping @Sendable @convention(block) () -> Void)
}

extension DispatchQueue: DispatchQueueType {
    func async(execute work: @escaping @Sendable @convention(block) () -> Void) {
        async(group: nil, execute: work)
    }
}
