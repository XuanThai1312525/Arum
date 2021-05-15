//
//  AppButton.swift
//  LANE4
//
//  Created by Thai Nguyen on 01/12/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class AppButton: UIButton {
   
    let bottomLineHeight: CGFloat = 1.0
    var bottomLine: CALayer?
    var arrowLeftImage: UIImageView?
    var arrowRightImage: UIImageView?
    var arrowDownImage: UIImageView?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let arrowLeftImage = self.arrowLeftImage {
            arrowLeftImage.center = CGPoint(x: 15, y: self.frame.height * 0.5)
        }
        if let arrowRightImage = self.arrowRightImage {
            arrowRightImage.center = CGPoint(x: self.frame.width - 20, y: self.frame.height * 0.5)
        }
        if let arrowDownImage = self.arrowDownImage {
            arrowDownImage.center = CGPoint(x: self.frame.width - 15, y: self.frame.height * 0.5)
        }
        self.updateButtomLineLayout()
    }
    
    @IBInspectable var fontSize: CGFloat = 14.0 {
        didSet {
            titleLabel?.font = Constants.fontBold(size: fontSize)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var cornerCircle: Bool = false {
        didSet {
            layer.cornerRadius = cornerCircle ? self.frame.size.height / 2 : 0
            layer.masksToBounds = cornerCircle
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var bottomBorder: Bool = false {
        didSet {
            if (self.bottomLine == nil) {
                self.bottomLine = CALayer()
                self.bottomLine?.borderWidth = bottomLineHeight
                self.layer.addSublayer(self.bottomLine!)
            }
            
            self.updateButtomLineLayout()
        }
    }
    
    @IBInspectable var isShadow: Bool = false {
        didSet {
            if isShadow {
                layer.shadowColor = UIColor.black.cgColor
                layer.shadowOpacity = 0.16
                layer.shadowRadius = 4.0
                layer.shadowOffset = CGSize(width: 0, height: 0)
                layer.masksToBounds = false
                //layer.shouldRasterize = true
            }
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var arrowLeft: UIImage? {
        didSet {
            if let arrowLeft = arrowLeft {
                arrowLeftImage = UIImageView(image: arrowLeft)
                self.addSubview(arrowLeftImage!)
                arrowLeftImage?.center = CGPoint(x: 15, y: self.frame.height * 0.5)
            } else {
                if let arrowLeftImage = arrowLeftImage {
                    arrowLeftImage.removeFromSuperview()
                }
            }
        }
    }
    
    @IBInspectable var arrowRight: UIImage? {
        didSet {
            if let arrowRight = arrowRight {
                arrowRightImage = UIImageView(image: arrowRight)
                self.addSubview(arrowRightImage!)
                arrowRightImage?.center = CGPoint(x: self.frame.width - 20, y: self.frame.height * 0.5)
            } else {
                if let arrowRightImage = arrowRightImage {
                    arrowRightImage.removeFromSuperview()
                }
            }
        }
    }
    
    @IBInspectable var arrowDown: UIImage? {
        didSet {
            if let arrowDown = arrowDown {
                arrowDownImage = UIImageView(image: arrowDown)
                self.addSubview(arrowDownImage!)
                arrowDownImage?.center = CGPoint(x: self.frame.width - 15, y: self.frame.height * 0.5)
            } else {
                if let arrowDownImage = arrowDownImage {
                    arrowDownImage.removeFromSuperview()
                }
            }
        }
    }
    
    private func updateButtomLineLayout() {
        if let line = self.bottomLine {
            let lineHeight = bottomLineHeight
            line.frame = CGRect(x: 0, y: self.frame.height - lineHeight, width: self.frame.width, height: lineHeight)
        }
    }
    
    
}






