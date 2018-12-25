//
//  MockServerManager.swift
//  PhoneDictionaryTests
//
//  Created by Pranalee Jadhav on 12/23/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import Foundation

extension Contact {
    func dummyContact(id: Int = 1, firstname: String = "pranalee", lastname: String = "jadhav", phonenumber: String = "7568968976") {
        return Contact(id: id,firstname: firstname,lastname: lastname,phonenumber: phonenumber)
    }
}

enum Result<T, U: Error> {
    case success(payload: T)
    case failure(U?)
}

enum EmptyResult<U: Error> {
    case success
    case failure(U?)
}

final class MockServerManager: ServerManager {
    var getContactsResult: Result<[Contact], ServerManager.FailureReason>?
    var deleteContactResult: Result<Void, ServerManager.FailureReason>?
    var updateContactResult: Result<Void, ServerManager.FailureReason>?
    
    override func getContacts() -> Observable<[Contact]> {
        return Observable.create { observer in
            switch self.getContactsResult {
            case .success(let contacts)?:
                observer.onNext(contacts)
            case .failure(let error)?:
                observer.onError(error!)
            case .none:
                observer.onError(ServerManager.FailureReason.notFound)
            }
            
            return Disposables.create()
        }
    }
    
    override func deleteContact(id: Int) -> Observable<Void> {
        return Observable.create { observer in
            switch self.deleteContactResult {
            case .success?:
                observer.onNext(())
            case .failure(let error)?:
                observer.onError(error!)
            case .none:
                observer.onError(ServerManager.FailureReason.notFound)
            }
            
            return Disposables.create()
        }
    }
    
    
    override func addContact(firstname: String, lastname: String, phonenumber: String) -> Observable<Void> {
        return Observable.create { observer in
            switch self.updateContactResult {
            case .success?:
                observer.onNext(())
            case .failure(let error)?:
                observer.onError(error!)
            case .none:
                observer.onError(ServerManager.FailureReason.notFound)
            }
            
            return Disposables.create()
        }
    }
    
    override func updateContact(firstname: String, lastname: String, phonenumber: String) -> Observable<Void> {
        return Observable.create { observer in
            switch self.updateContactResult {
            case .success?:
                observer.onNext(())
            case .failure(let error)?:
                observer.onError(error!)
            case .none:
                observer.onError(ServerManager.FailureReason.notFound)
            }
            
            return Disposables.create()
        }
    }
}
