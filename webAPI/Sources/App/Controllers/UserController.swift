//
//  UserController.swift
//  App
//
//  Created by Pranalee Jadhav on 12/22/18.
//

import Vapor

final class UserController {
    
    
    func list(_ req: Request) throws -> Future<[User]> { // Vapor utilizes the Future type to provide a reference to an object that isn’t available yet.
        

        return User.query(on: req).all()
    }
    
    func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
    }
    
    
    func update(_ req: Request) throws -> Future<User> {
        return try flatMap(to: User.self, req.parameters.next(User.self), req.content.decode(User.self)) { user, updatedUser in
            user.firstname = updatedUser.firstname
            user.lastname = updatedUser.lastname
            user.phonenumber = updatedUser.phonenumber
            return user.save(on: req)
        }
    }
    
    func delete(_ req: Request) throws -> Future<Dictionary<String, String>> {
        return try req.parameters.next(User.self).flatMap(to: Void.self) { user in
            return user.delete(on: req)
            }.transform(to: [:])
    }
    
}
