//
//  ValidateInputView.swift
//  Earable
//
//  Created by Admim on 11/12/20.
//  Copyright © 2020 Earable. All rights reserved.
//

import UIKit

struct TextInputViewAppear {
    var descriptionText: String
    var validText: String?
    var isShowValidText: Bool = false
    var invalidText:String?
    var invalidColor: UIColor = .red
    var validColor: UIColor = .blue
}

typealias ValidateInput = (String)->Bool

class TextInputView: UIView {
    @IBOutlet weak var inputTextfield: UITextField!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var validateLabel: UILabel!
    
    @IBOutlet weak var view: UIView!
    var validateInput: ValidateInput?
    var appearance: TextInputViewAppear?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        Bundle.main.loadNibNamed("TextInputView", owner: self, options: nil)
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.fullscreen()
    }
    
    func appearance(_ info: TextInputViewAppear) {
        underlineView.backgroundColor = info.validColor
        underlineView.round(1.5)
        
        if let validText = info.validText {
            validateLabel.text = validText
            validateLabel.textColor = info.validColor
            validateLabel.isHidden = false
        }
        
        inputTextfield.delegate = self
        inputTextfield.attributedPlaceholder = NSAttributedString(string: info.descriptionText,
                                                                  attributes: [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.7803921569, green: 0.8078431373, blue: 0.8901960784, alpha: 1)])
        appearance = info
    }
    
    func validateInput(_ completion: @escaping ValidateInput) {
        validateInput = completion
    }
    
    func bindingUI(isValid: Bool) {
        underlineView.backgroundColor = isValid ? appearance?.validColor : appearance?.invalidColor
        validateLabel.text = isValid ? appearance?.validText : appearance?.invalidText
        underlineView.backgroundColor = isValid ? appearance?.validColor : appearance?.invalidColor
        validateLabel.textColor = isValid ? appearance?.validColor : appearance?.invalidColor
      
    }

}

extension TextInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, let validateInput = validateInput {
            bindingUI(isValid: validateInput(text))
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if (textField.text?.isEmpty ?? true) {
            textField.placeholder = appearance?.descriptionText
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
}


