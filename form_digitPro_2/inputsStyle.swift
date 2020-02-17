//
//  inputsStyle.swift
//  form_digitPro_2
//
//  Created by Freddy Romero Espinosa on 2/16/20.
//  Copyright © 2020 Freddy Romero Espinosa. All rights reserved.
//

import UIKit

enum InputsStyle:Int{
    
    case name
    case lastName
    case secondLastName
    case email
    case phone
}

struct ValueInput {
    
    static var name:String = ""
    static var lastName:String = ""
    static var secondLastName:String = ""
    static var email:String = ""
    static var phone:String = "525555555555"
    
   
}



var areValuesInputOk:[String:Bool] = [ "name" : false,  "lastName" : false,  "secondLastName" : false,  "mail" : false,  "phone" : false ]
