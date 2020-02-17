//
//  extensions.swift
//  form_digitPro_2
//
//  Created by Freddy Romero Espinosa on 2/16/20.
//  Copyright © 2020 Freddy Romero Espinosa. All rights reserved.
//

import UIKit


extension UIView {
    func pin(to superview:UIView){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
}

enum RegexCases:String {
    case name = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]){1}$"
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case phone =  "^[0-9]{10}$"
}

extension String {
    
    func isValidRegex(_ inputsStyle:InputsStyle)->Bool {
        
        let format = "SELF MATCHES %@"
        var regex = ""
        
        switch inputsStyle {
        case .name:
            regex = RegexCases.name.rawValue
        case .email:
            regex = RegexCases.email.rawValue
        case .phone:
            regex = RegexCases.phone.rawValue
        default:
            regex = ""
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
}



extension UITextField{
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}
