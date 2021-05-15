//
//  UIImageView+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

extension UIImageView {
    func loadImage(url: URL?,
                   headers: HTTPHeaders? = nil,
                   placeholder: UIImage? = nil,
                   timeout: TimeInterval? = nil,
                   showIndicator: Bool = false,
                   forceRefresh: Bool = false,
                   progressBlock: ((_ receivedSize: Int64, _ totalSize: Int64, _ percentage: Double) -> Void)? = nil,
                   completion: ((_ image: UIImage?, _ error: Error?, _ url: URL?) -> Void)? = nil) {
        if showIndicator {
            kf.indicator?.startAnimatingView()
        }
        var options: KingfisherOptionsInfo = [.transition(.fade(0.2))]
        if forceRefresh {
            options.append(.forceRefresh)
        }
        let modifier = AnyModifier { request in
            var r = request
            if let getTimeout = timeout {
                r.timeoutInterval = getTimeout
            }
            if let getHeaders = headers, !getHeaders.isEmpty {
                for (key, value) in getHeaders.dictionary {
                    r.setValue(value, forHTTPHeaderField: key)
                }
            }
            return r
        }
        options.append(.requestModifier(modifier))
        kf.setImage(with: url, placeholder: placeholder, options: options, progressBlock: { receivedSize, totalSize in
            guard let _ = progressBlock else { return }
            let percentage = Double(totalSize) / Double(receivedSize)
            progressBlock?(receivedSize, totalSize, percentage)
        }, completionHandler: { [weak self] result in
            if showIndicator {
                self?.kf.indicator?.stopAnimatingView()
            }
            switch result {
            case .success(let value):
                completion?(value.image, nil, value.source.url)
            case .failure(let error):
                completion?(nil, error, nil)
            }
        })
    }
    
    func cancelLoadingImage() {
        self.kf.cancelDownloadTask()
    }
    
    func set(color: UIColor) {
        image = image?.template
        tintColor = color
    }
    
    func renderOriginal() {
        image = image?.template
    }
    
    func renderTemplate() {
        image = image?.template
    }
    
    func roundRectWith(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        shape.backgroundColor = UIColor.red.cgColor
        self.layer.mask = shape
    }
}
