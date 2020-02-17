//
//  itemListCell.swift
//  form_digitPro_2
//
//  Created by Freddy Romero Espinosa on 2/15/20.
//  Copyright © 2020 Freddy Romero Espinosa. All rights reserved.
//

import UIKit

class itemListCell: UITableViewCell, UITextFieldDelegate {
    
    var itemImageView = UIImageView()
    var itemTitleLabel = UILabel()
    var itemTextField = UITextField()
    var bottomBorder = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.addGestureRecognizer(tap)
        
        
        addSubview(itemImageView)
        addSubview(itemTitleLabel)
        addSubview(itemTextField)
        
        configureImageView()
        configureTitleLabel()
        configureTextField()
        setImagesConstraints()
        setTitleLabelConstraints()
        setIextFieldConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(item:ItemInput){
        itemImageView.image = item.image
        itemTitleLabel.text = item.title
        itemTextField.tag = item.tag
    }
    
    func configureImageView(){
        itemImageView.layer.cornerRadius = 1
        itemImageView.clipsToBounds = true
    }
    
    func configureTitleLabel(){
        itemTitleLabel.numberOfLines = 0
        itemTitleLabel.adjustsFontSizeToFitWidth = true
        itemTitleLabel.font = UIFont(name:"Verdana" , size: 20)
    }
    
    func configureTextField(){
        
        bottomBorder = UIView.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bottomBorder.backgroundColor = UIColor.gray
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false

        addSubview(bottomBorder)
        bottomBorder.translatesAutoresizingMaskIntoConstraints = false
        bottomBorder.centerYAnchor.constraint(equalTo:
            itemTextField.bottomAnchor).isActive = true
        bottomBorder.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        bottomBorder.heightAnchor.constraint(equalToConstant: 2).isActive = true
        bottomBorder.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
                
        itemTextField.borderStyle = .none
        itemTextField.delegate = self
        
        itemTextField.addTarget(self, action: #selector(handleTextChange), for: .editingChanged)
    
    }
    
    func setImagesConstraints(){
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        itemImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        itemImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        itemImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        itemImageView.widthAnchor.constraint(equalTo: itemImageView.heightAnchor, multiplier: 1).isActive = true
    }
    
    func setTitleLabelConstraints() {
        itemTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        itemTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        itemTitleLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 10).isActive = true
        itemTitleLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        itemTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
    func setIextFieldConstraints() {
        itemTextField.translatesAutoresizingMaskIntoConstraints = false
        itemTextField.centerYAnchor.constraint(equalTo: bottomAnchor).isActive = true
        itemTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        itemTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        itemTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
        return true
   }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
                
        switch textField.tag {
        case InputsStyle.name.rawValue, InputsStyle.lastName.rawValue, InputsStyle.secondLastName.rawValue:
                itemTextField.keyboardType = .default
            case InputsStyle.email.rawValue:
                itemTextField.keyboardType = .emailAddress
            case InputsStyle.phone.rawValue:
                itemTextField.keyboardType = .phonePad
                textField.addDoneButtonOnKeyboard()

            default:
                itemTextField.keyboardType = .default
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        var arrBool = [Bool]()
        
        for (_, val) in areValuesInputOk {
            
            arrBool.append(val)
            
        }
        
        if !arrBool.contains(false) {
            ItemListVC.isActiveButton = true
        } else {
            ItemListVC.isActiveButton = false

        }
        

       
    }
    
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
        
    }
    
    @objc func handleTextChange () {
        switch itemTextField.tag {
        case 0:
            ValueInput.name = itemTextField.text ?? ""
            checkRegex(inTag:InputsStyle.name)
        case 1:
            ValueInput.lastName = itemTextField.text ?? ""
            checkRegex(inTag:InputsStyle.lastName)
        case 2:
            ValueInput.secondLastName = itemTextField.text ?? ""
            checkRegex(inTag:InputsStyle.secondLastName)
        case 3:
            ValueInput.email = itemTextField.text ?? ""
            checkRegex(inTag:InputsStyle.email)
        case 4:
            ValueInput.phone = itemTextField.text ?? ""
            checkRegex(inTag:InputsStyle.phone)
        default:
            print("No implementado")
        }
        
    }
    
    func checkRegex(inTag:InputsStyle) {
        switch inTag {
        case .name:
            
            if(ValueInput.name.isValidRegex(.name)){
                areValuesInputOk["name"] = true
                changeUIResponseRegex(isActive: true, toIcon: ImagesIcons.nameOk ?? UIImage())
            } else {
                areValuesInputOk["name"] = false
                changeUIResponseRegex(isActive: false, toIcon: ImagesIcons.name ?? UIImage())
            }
        case .lastName:
            if(ValueInput.lastName.isValidRegex(.name)){
                areValuesInputOk["lastName"] = true
                changeUIResponseRegex(isActive: true, toIcon: ImagesIcons.nameOk ?? UIImage())
            }else {
                areValuesInputOk["lastName"] = false
                changeUIResponseRegex(isActive: false, toIcon: ImagesIcons.name ?? UIImage())
            }
        case .secondLastName:
            if(ValueInput.secondLastName.isValidRegex(.name)){
                areValuesInputOk["secondLastName"] = true
                changeUIResponseRegex(isActive: true, toIcon: ImagesIcons.nameOk ?? UIImage())
            }else {
                areValuesInputOk["secondLastName"] = false
                changeUIResponseRegex(isActive: false, toIcon: ImagesIcons.name ?? UIImage())
            }
        case .email:
            if(ValueInput.email.isValidRegex(.email)){
                areValuesInputOk["mail"] = true
                changeUIResponseRegex(isActive: true, toIcon: ImagesIcons.mailOk ?? UIImage())
            }else {
                areValuesInputOk["mail"] = false
                changeUIResponseRegex(isActive: false, toIcon: ImagesIcons.mail ?? UIImage())
            }
        case .phone:
            if(ValueInput.phone.isValidRegex(.phone)){
                areValuesInputOk["phone"] = true
                changeUIResponseRegex(isActive: true, toIcon:ImagesIcons.phoneOk ?? UIImage())
            }else {
                areValuesInputOk["phone"] = true
                changeUIResponseRegex(isActive: false, toIcon: ImagesIcons.phone ?? UIImage())
            }
            
        }
    }
    
    func changeUIResponseRegex(isActive:Bool, toIcon:UIImage) {
        if(isActive){
            bottomBorder.backgroundColor = UIColor.blue
            itemImageView.image = toIcon
        } else {
            bottomBorder.backgroundColor = UIColor.red
            itemImageView.image = toIcon

        }
    }
    
   
}
