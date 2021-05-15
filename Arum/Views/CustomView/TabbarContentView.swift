//
//  TabbarContentView.swift
//  LANE4
//
//  Created by Thai Nguyen on 30/11/2020.
//  Copyright © 2020 LinhNM7. All rights reserved.
//

import Foundation
import UIKit


class TabbarContentView: ESTabBarItemContentView {

    public var duration = 0.3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textColor = .init(red: 229, green: 231, blue: 236)
        iconColor = .init(red: 229, green: 231, blue: 236)
        titleFont = UIFont.systemFont(ofSize: 14)
        highlightTextColor = UIColor(hex: "ffc013")
        highlightIconColor = UIColor(hex: "ffc013")
        renderingMode = .alwaysTemplate
        backdropColor = UIColor.init(hex: "#021727")
        highlightBackdropColor = UIColor.init(hex: "#1a3d58")
        imageView.contentMode = .scaleAspectFit
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func selectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }

    override func reselectAnimation(animated: Bool, completion: (() -> ())?) {
        self.bounceAnimation()
        completion?()
    }
    
    func bounceAnimation() {
        let impliesAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        impliesAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        impliesAnimation.duration = duration * 2
        impliesAnimation.calculationMode = CAAnimationCalculationMode.cubic
        imageView.layer.add(impliesAnimation, forKey: nil)
    }
    

}
