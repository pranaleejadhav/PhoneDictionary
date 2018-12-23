//
//  User.swift
//  App
//
//  Created by Pranalee Jadhav on 12/22/18.
//

import FluentPostgreSQL  // changed
import Vapor
final class User: PostgreSQLModel {
    var id: Int?
    var firstname: String
    var lastname: String
    var phonenumber: String
    
    
    init(id: Int? = nil, firstname: String, lastname: String, phonenumber: String) {
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.phonenumber = phonenumber
    }
}
extension User: Content {}
extension User: Migration {}
extension User: Parameter { }

