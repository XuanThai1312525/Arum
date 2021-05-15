//
//  CustomNibView.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

class CustomNibView: UIView {

    // MARK: - Outlets
    @IBOutlet var contentView: UIView!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        guard let xibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last else { return }
        Bundle(for: type(of: self)).loadNibNamed(xibName, owner: self, options: nil)
        //frame.size = contentView.frame.size
        addSubview(contentView)
        contentView.fitTo(superView: self)
        backgroundColor = .clear
    }
}
