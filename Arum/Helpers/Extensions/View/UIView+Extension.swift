//
//  UIView+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit

private var kViewTopConstraint: UInt8 = 0
private var kViewLeftConstraint: UInt8 = 0
private var kViewRightConstraint: UInt8 = 0
private var kViewBottomConstraint: UInt8 = 0
private var kViewWidthConstraint: UInt8 = 0
private var kViewHeightConstraint: UInt8 = 0
private var kViewRatioConstraint: UInt8 = 0
private var kViewCenterXConstraint: UInt8 = 0
private var kViewCenterYConstraint: UInt8 = 0
private var kViewAdditionalConstraints: UInt8 = 0
extension UIView { // layout vars
    var privateAdditionalConstraints: [String: NSLayoutConstraint]? {
        get {
            return objc_getAssociatedObject(self, &kViewAdditionalConstraints) as? [String: NSLayoutConstraint]
        }
        set {
            objc_setAssociatedObject(self, &kViewAdditionalConstraints, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var additionalConstraints: [String: NSLayoutConstraint] {
        get {
            if privateAdditionalConstraints == nil {
                privateAdditionalConstraints = [:]
            }
            return privateAdditionalConstraints!
        }
        set {
            privateAdditionalConstraints = newValue
        }
    }
    
    @IBOutlet var centerXLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewCenterXConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewCenterXConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet var centerYLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewCenterYConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewCenterYConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet var topLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewTopConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewTopConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet var leftLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewLeftConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewLeftConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet var bottomLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewBottomConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewBottomConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet var rightLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewRightConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewRightConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet var widthLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewWidthConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewWidthConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet var heightLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewHeightConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewHeightConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet var ratioLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewRatioConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewRatioConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

enum ViewFullScreenType {
    case TopLeftBottomRight
    case CenterXYWidthHeight
}

extension UIView { // layout
    func setAdditionalConstraint(_ constraint: NSLayoutConstraint, forKey key: String) {
        NSLayoutConstraint.activate([constraint])
        additionalConstraints[key] = constraint
    }
    
    func fullscreen(_ relativeView: UIView? = nil, type: ViewFullScreenType = .TopLeftBottomRight) {
        var view = relativeView
        if view == nil {
            view = superview
        }
        guard let sup = view else {return}
        translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .CenterXYWidthHeight:
            setCenterX(0.0, relativeToView: sup)
            setCenterY(0.0, relativeToView: sup)
            setWidth(0.0, relativeToView: sup)
            setHeight(0.0, relativeToView: sup)
            
        default:
            setTop(0.0, relativeToView: sup)
            setLeft(0.0, relativeToView: sup)
            setBottom(0.0, relativeToView: sup)
            setRight(0.0, relativeToView: sup)
        }
    }
    
    func centralize() {
        guard let sup = superview else {return}
        translatesAutoresizingMaskIntoConstraints = false
        setCenterX(0.0, relativeToView: sup)
        setCenterY(0.0, relativeToView: sup)
    }
    
    @discardableResult
    func setCenterX(_ constant: CGFloat, relativeToView: UIView, relativeAttribute: NSLayoutConstraint.Attribute = .centerX) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        centerXLayoutConstraint?.deactivate()
        let centerXCons = NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: relativeToView, attribute: relativeAttribute, multiplier: 1.0, constant: constant)
        NSLayoutConstraint.activate([centerXCons])
        centerXLayoutConstraint = centerXCons
        return self
    }
    
    @discardableResult
    func setCenterY(_ constant: CGFloat, relativeToView: UIView, relativeAttribute: NSLayoutConstraint.Attribute = .centerY) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        centerYLayoutConstraint?.deactivate()
        let centerYCons = NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: .equal, toItem: relativeToView, attribute: relativeAttribute, multiplier: 1.0, constant: constant)
        NSLayoutConstraint.activate([centerYCons])
        centerYLayoutConstraint = centerYCons
        return self
    }
    
    @discardableResult
    func setTop(_ constant: CGFloat, relativeToView: UIView, relativeAttribute: NSLayoutConstraint.Attribute = .top) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        topLayoutConstraint?.deactivate()
        let topCons = NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: relativeToView, attribute: relativeAttribute, multiplier: 1.0, constant: constant)
        NSLayoutConstraint.activate([topCons])
        topLayoutConstraint = topCons
        return self
    }
    
    @discardableResult
    func setLeft(_ constant: CGFloat, relativeToView: UIView, relativeAttribute: NSLayoutConstraint.Attribute = .left) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        leftLayoutConstraint?.deactivate()
        let leftCons = NSLayoutConstraint.init(item: self, attribute: .left, relatedBy: .equal, toItem: relativeToView, attribute: relativeAttribute, multiplier: 1.0, constant: constant)
        NSLayoutConstraint.activate([leftCons])
        leftLayoutConstraint = leftCons
        return self
    }
    
    @discardableResult
    func setBottom(_ constant: CGFloat, relativeToView: UIView, relativeAttribute: NSLayoutConstraint.Attribute = .bottom, relatedBy: NSLayoutConstraint.Relation = .equal) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        bottomLayoutConstraint?.deactivate()
        let bottomCons = NSLayoutConstraint.init(item: self, attribute: .bottom, relatedBy: relatedBy, toItem: relativeToView, attribute: relativeAttribute, multiplier: 1.0, constant: constant)
        NSLayoutConstraint.activate([bottomCons])
        bottomLayoutConstraint = bottomCons
        return self
    }
    
    @discardableResult
    func setRight(_ constant: CGFloat, relativeToView: UIView, relativeAttribute: NSLayoutConstraint.Attribute = .right) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        rightLayoutConstraint?.deactivate()
        let rightCons = NSLayoutConstraint.init(item: self, attribute: .right, relatedBy: .equal, toItem: relativeToView, attribute: relativeAttribute, multiplier: 1.0, constant: constant)
        NSLayoutConstraint.activate([rightCons])
        rightLayoutConstraint = rightCons
        return self
    }
    
    @discardableResult
    func setWidth(_ constant: CGFloat, relativeToView: UIView? = nil, relation: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1.0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        widthLayoutConstraint?.deactivate()
        let widthCons = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: relativeToView, attribute: relativeToView == nil ? .notAnAttribute : .width, multiplier: multiplier, constant: constant)
        NSLayoutConstraint.activate([widthCons])
        widthLayoutConstraint = widthCons
        return self
    }
    
    @discardableResult
    func setHeight(_ constant: CGFloat, relativeToView: UIView? = nil, relation: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1.0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        heightLayoutConstraint?.deactivate()
        let heightCons = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: relation, toItem: relativeToView, attribute: relativeToView == nil ? .notAnAttribute : .height, multiplier: multiplier, constant: constant)
        NSLayoutConstraint.activate([heightCons])
        heightLayoutConstraint = heightCons
        return self
    }
    
    @discardableResult
    func setRatio(_ r: CGFloat, c: CGFloat = 0.0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        ratioLayoutConstraint?.deactivate()
        let ratioCons = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: r, constant: c)
        NSLayoutConstraint.activate([ratioCons])
        ratioLayoutConstraint = ratioCons
        return self
    }
    
    func round(_ radius: CGFloat, color: UIColor = .clear, width: CGFloat = 0) {
        layer.cornerRadius = radius
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.masksToBounds = true
    }
}

protocol XibView {
    static var name: String { get }
    static func createFromXib() -> Self
}

extension XibView where Self: UIView {
    static var name: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
    
    static func createFromXib() -> Self {
        return Self.init()
    }
}

extension UIView: XibView { }

extension UIView {
    /** Loads instance from nib with the same name. */
    static func loadNib() -> UIView {
        let nib = UINib(nibName: name, bundle: .main)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
    
    func loadViewFromNib(name: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: name, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
}

//// MARK: - Extension for Inspectable
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(value) {
            clipsToBounds = true
            layer.cornerRadius = value
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let borderColor = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: borderColor)
        }
        set(value) {
            layer.borderColor = value?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(value) {
            layer.borderWidth = value
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set(value) {
            layer.shadowOffset = value
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set(value) {
            layer.shadowRadius = value
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set(value) {
            layer.shadowOpacity = value
        }
    }
    
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: layer.shadowColor ?? UIColor.clear.cgColor)
        }
        set(value) {
            layer.shadowColor = value.cgColor
        }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get {
            return layer.masksToBounds
        }
        set(value) {
            layer.masksToBounds = value
        }
    }
}

// MARK: - Extension for all
extension UIView {
    // MARK: - Variables
    var name: String {
        return type(of: self).name
    }
    
    var subviewsRecursive: [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive }
    }
    
    var parentViewController: UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.parentViewController
        } else {
            return nil
        }
    }
    
    var globalPointWithEntireScreen: CGPoint? {
        return superview?.convert(frame.origin, to: nil)
    }
    
    var globalFrameWithEntireScreen: CGRect? {
        return superview?.convert(frame, to: nil)
    }

    // MARK: - Local functions
    func set(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
    }
    
    func set(borderWidth: CGFloat, withColor color: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = color.cgColor
    }
    
    func set(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        set(cornerRadius: cornerRadius)
        set(borderWidth: borderWidth, withColor: borderColor)
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func setShadow(color: UIColor, opacity: Float, offSet: CGSize, radius: CGFloat) {
        clipsToBounds = false
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
    }
    
    func setGradientBackground(startColor: UIColor, endColor: UIColor, gradientDirection: GradientDirection) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientLayer.startPoint = gradientDirection.draw().x
        gradientLayer.endPoint = gradientDirection.draw().y
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

// Extension for cutting & masking layers
extension UIView {
    func cut(rect: CGRect) {
        let p:CGMutablePath = CGMutablePath()
        p.addRect(bounds)
        p.addRect(rect)
        
        let s = CAShapeLayer()
        s.path = p
        s.fillRule = CAShapeLayerFillRule.evenOdd
        
        self.layer.mask = s
    }
    
    func cut(path: CGPath) {
        let p:CGMutablePath = CGMutablePath()
        p.addRect(bounds)
        p.addPath(path)
        
        let s = CAShapeLayer()
        s.path = p
        s.fillRule = CAShapeLayerFillRule.evenOdd
        
        layer.mask = s
    }
}

// Extension for autolayout
extension UIView {
    static let maxPriority: UILayoutPriority = UILayoutPriority(999)
    static let minPriority: UILayoutPriority = UILayoutPriority(1)
    
    @discardableResult
    func centerTo(superView: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            getEqualConstraintTo(superView: superView, attribute: .centerX),
            getEqualConstraintTo(superView: superView, attribute: .centerY)
        ]
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    func fitTo(superView: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            getEqualConstraintTo(superView: superView, attribute: .top),
            getEqualConstraintTo(superView: superView, attribute: .left),
            getEqualConstraintTo(superView: superView, attribute: .right),
            getEqualConstraintTo(superView: superView, attribute: .bottom)
        ]
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    func sameSizeTo(superView: UIView) -> [NSLayoutConstraint] {
        let constraints: [NSLayoutConstraint] = [
            getEqualConstraintTo(superView: superView, attribute: .width),
            getEqualConstraintTo(superView: superView, attribute: .height)
        ]
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraints(constraints)
        return constraints
    }
    
    @discardableResult
    func sameWidthTo(superView: UIView) -> NSLayoutConstraint {
        let constraint = getEqualConstraintTo(superView:superView, attribute: .width)
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func sameHeightTo(superView: UIView) -> NSLayoutConstraint {
        let constraint = getEqualConstraintTo(superView:superView, attribute: .height)
        translatesAutoresizingMaskIntoConstraints = false
        superView.addConstraint(constraint)
        return constraint
    }
    
    @discardableResult
    func setRatioWith(multiplier: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        let constraint = getRatioConstraintWith(multiplier: multiplier)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    
    func getEqualConstraintTo(superView: UIView,
                              attribute: NSLayoutConstraint.Attribute,
                              constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: superView,
                                            attribute: attribute,
                                            multiplier: 1,
                                            constant: constant)
        return constraint
    }
    
    func getFixedConstraintWith(attribute: NSLayoutConstraint.Attribute,
                                value: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: value)
        return constraint
    }
    
    func getRelatedConstraintTo(superView: UIView,
                                attribute: NSLayoutConstraint.Attribute,
                                relatedBy: NSLayoutConstraint.Relation,
                                constant: CGFloat = 0.0) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: attribute,
                                            relatedBy: relatedBy,
                                            toItem: superView,
                                            attribute: attribute,
                                            multiplier: 1,
                                            constant: constant)
        return constraint
    }
    
    func getRatioConstraintWith(multiplier: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: self,
                                            attribute: .width,
                                            multiplier: multiplier,
                                            constant: 0)
        return constraint
    }
}

extension UIView {
    //MARK: Add Gesture Recognizer
    func addSingleTapGesture(target: Any?, selector: Selector) -> Void {
        let tap = UITapGestureRecognizer(target: target, action: selector)
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    func flash(numberOfFlashes: Float) {
        layer.removeAllAnimations()
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.5
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = numberOfFlashes
        layer.add(flash, forKey: "animation.flash")
    }
}

extension NSLayoutConstraint {
    func deactivate() {
        NSLayoutConstraint.deactivate([self])
    }
}

extension UIControl.Event: Hashable {
    public func hash(into hasher: inout Hasher) {
        var key = ""
        switch self {
        case .touchUpInside:
            key = "touchUpInside"
            
        case .editingChanged:
            key = "editingChanged"
            
        case .editingDidEnd:
            key = "editingDidEnd"
            
        case .editingDidEndOnExit:
            key = "editingDidEndOnExit"
            
        case .editingDidBegin:
            key = "editingDidBegin"
            
        case .valueChanged:
            key = "valueChanged"
            
        default:
            assertionFailure("did not support \(self) yet")
        }
        hasher.combine(key)
    }
}

private var kControlHandlers: UInt8 = 0
extension UIControl {
    typealias ControlHandler = ((UIControl, Any?) -> Void)
    
    var controlHandlers: [UIControl.Event: ControlHandler] {
        get {
            var handlers = objc_getAssociatedObject(self, &kControlHandlers) as? [UIControl.Event: ControlHandler]
            if handlers == nil {
                handlers = [:]
                self.controlHandlers = handlers!
            }
            return handlers!
        }
        set {
            objc_setAssociatedObject(self, &kControlHandlers, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func selector(for event: UIControl.Event) -> Selector {
        var sel: Selector!
        switch event {
        case .touchUpInside:
            sel = #selector(did_touchUpInside(_:))
            
        case .editingDidEnd:
            sel = #selector(did_endEditing(_:))
            
        case .editingChanged:
            sel = #selector(did_changed(_:))
            
        case .editingDidBegin:
            sel = #selector(did_beginEditing(_:))
            
        case .editingDidEndOnExit:
            sel = #selector(did_endOnExitEditing(_:))
            
        case .valueChanged:
            sel = #selector(did_changeValue(_:))
            
        default:
            assertionFailure("UIControl did not support \(event) yet")
        }
        return sel
    }
    
    func did(_ event: UIControl.Event, handler: @escaping ControlHandler) {
        controlHandlers[event] = handler
        addTarget(self, action: selector(for: event), for: event)
    }
    
    func fire(event: UIControl.Event, value: Any?) {
        controlHandlers[event]?(self, value)
    }
    
    @objc func did_beginEditing(_ sender: Any) {
        fire(event: .editingDidBegin, value: nil)
    }
    
    @objc func did_changed(_ sender: Any) {
        fire(event: .editingChanged, value: nil)
    }
    
    @objc func did_endEditing(_ sender: Any) {
        fire(event: .editingDidEnd, value: nil)
    }
    
    @objc func did_endOnExitEditing(_ sender: Any) {
        fire(event: .editingDidEndOnExit, value: nil)
    }
    
    @objc func did_changeValue(_ sender: Any) {
        switch sender {
        case let sw as UISwitch:
            fire(event: .valueChanged, value: sw.isOn)
            
        case let sl as UISlider:
            fire(event: .valueChanged, value: sl.value)
            
        default:
            fire(event: .valueChanged, value: nil)
        }
    }
    
    @objc func did_touchUpInside(_ sender: Any) {
        fire(event: .touchUpInside, value: nil)
    }
}
