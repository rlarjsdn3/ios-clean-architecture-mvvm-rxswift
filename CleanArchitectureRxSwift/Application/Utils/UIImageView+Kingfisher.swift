//
//  UIImageView+Kingfisher.swift
//  CleanArchitectureRxSwift
//
//  Created by 김건우 on 10/1/24.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift

typealias ImageOptions = KingfisherOptionsInfo

enum ImageResult {
    case success(UIImage)
    case failure(Error)
    
    var image: UIImage? {
        if case .success(let image) = self {
            return image
        } else {
            return nil
        }
    }
    
    var error: Error? {
        if case .failure(let error) = self {
            return error
        } else {
            return nil
        }
    }
}

extension UIImageView {
    
    func setImage(with urlString: String) {
        let cache = ImageCache.default
        cache.retrieveImage(
            forKey: urlString,
            options: nil,
            callbackQueue: .mainAsync
        ) { result in
            self.image = {
                if case let .success(cache) = result {
                    switch cache {
                    case let .disk(image), let .memory(image):
                        return image
                    default:
                        return nil
                    }
                } else {
                    return nil
                }
            }()
        }
    }
    
}
