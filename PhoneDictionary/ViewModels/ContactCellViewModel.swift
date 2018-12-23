//
//  ContactCellViewModel.swift
//  PhoneDictionary
//
//  Created by Pranalee Jadhav on 12/23/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

struct ContactCellViewModel {
    let firstname: String
    let lastname: String
    let phonenumber: String
    let id: Int
}


extension ContactCellViewModel {
    init(contact: Contact) {
        self.firstname = contact.firstname
        self.lastname = contact.lastname
        self.phonenumber = contact.phonenumber
        self.id = contact.id
    }
}
