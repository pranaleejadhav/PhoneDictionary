//
//  Contact.swift
//  PhoneDictionary
//
//  Created by Pranalee Jadhav on 12/23/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

struct Contact: Decodable { //or write Codable , typealias Codable = Decodable & Encodable
    let id : Int
    let firstname : String
    let lastname : String
    let phonenumber : String
}
