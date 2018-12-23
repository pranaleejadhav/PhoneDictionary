//
//  ServerManager.swift
//  PhoneDictionary
//
//  Created by Pranalee Jadhav on 12/23/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import Alamofire
import RxSwift

class ServerManager {
    
    let server_url = "https://guarded-taiga-65140.herokuapp.com/users"
    
    func getContacts() -> Observable<[Contact]> {
        
        return Observable.create { observer -> Disposable in
            Alamofire.request(self.server_url)
                .validate()
                .responseJSON{ response in
                    switch response.result {
                        case .success:
                            guard let data = response.data else {
                                observer.onError(response.error ?? FailureReason.notFound)
                                return
                            }
                            do {
                                let contacts = try JSONDecoder().decode([Contact].self, from: data) //convert a set of data from a JSON Object or Property List to an equivalent StructorClass
                                observer.onNext(contacts)
                            } catch {
                                observer.onError(error)
                            }
                        
                        case .failure(let error):
                            if let statusCode = response.response?.statusCode, let reason = FailureReason(rawValue: statusCode) {
                                observer.onError(reason)
                            } else {
                                observer.onError(error)
                            }
                        
                    }
            }
            return Disposables.create()
        }
        
    }
    
    func deleteContact(id: Int) -> Observable<Void> {
        return Observable.create{ observer in
            Alamofire.request("\(self.server_url)\'\(id)", method: .delete, parameters: nil, encoding: JSONEncoding.default)
                .validate()
                .responseJSON{ response in
                    switch(response.result){
                    case .success:
                        observer.onNext(())
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode, let reason = FailureReason(rawValue: statusCode) {
                            observer.onError(reason)
                        } else {
                            observer.onError(error)
                        }
                    }
                }
            return Disposables.create()
        }
    }
    
    enum FailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }
}

