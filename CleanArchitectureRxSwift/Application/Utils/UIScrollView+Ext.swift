//
//  UIScrollView+Ext.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import UIKit

import RxSwift

extension UIScrollView {
    
    func reachedBottom(yOffset: CGFloat = 0) -> Observable<Void> {
        return rx.contentOffset
            .flatMap { [weak self] contentOffset -> Observable<Void> in
                guard let scrollView = self else {
                    return Observable.empty()
                }
                
                let visibleHeight = scrollView.frame.size.height - scrollView.contentInset.top - scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                
                return y > threshold ? Observable.just(()) : Observable.empty()
            }
    }
    
}
