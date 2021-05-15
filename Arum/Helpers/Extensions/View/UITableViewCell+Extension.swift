//
//  UITableViewCell+Extension.swift
//  iOS Structure MVC
//
//  Created by Vinh Dang on 2/9/19.
//  Copyright © 2019 vinhdd. All rights reserved.
//

import UIKit

// MARK: - UITableViewCell
protocol XibTableViewCell {
    static var name: String { get }
    static func registerCellTo(tableView: UITableView)
    static func reusableCellFor(tableView: UITableView, at indexPath: IndexPath) -> Self?
}

extension XibTableViewCell where Self: UITableViewCell {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last ?? ""
    }
    
    static func registerCellTo(tableView: UITableView) {
        tableView.registerNibCellFor(type: Self.self)
    }
    
    static func reusableCellFor(tableView: UITableView, at indexPath: IndexPath) -> Self? {
        return tableView.dequeueReusableCell(withIdentifier: name, for: indexPath) as? Self
    }
}

extension UITableViewCell: XibTableViewCell {
    func setSelectedBackgroundColor(_ color: UIColor) {
        let bgView = UIView(frame: self.frame)
        bgView.backgroundColor = color
        selectedBackgroundView = bgView
    }
}
