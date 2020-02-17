//
//  PersonClass.swift
//  form_digitPro_2
//
//  Created by Freddy Romero Espinosa on 2/17/20.
//  Copyright © 2020 Freddy Romero Espinosa. All rights reserved.
//

import Foundation

class Person
{
    
    var name: String = "Fred"
    var lastName: String = "Rom"
    var secondLastN:String = "Esp"
    var email:String = "fred@dkf.com"
    var phone:String = "5542321233"
    var id: Int = 0
    
    init(id:Int, name:String, lastName:String, secondLastN:String, email:String, phone:String)
    {
        self.id = id
        self.name = name
        self.lastName = lastName
        self.secondLastN = secondLastN
        self.email = email
        self.phone = phone
    }
    
}
