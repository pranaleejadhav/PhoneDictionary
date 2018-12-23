//
//  UpdateFriendViewModel.swift
//  PhoneDictionary
//
//  Created by Pranalee Jadhav on 12/23/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import RxSwift

protocol ContactUpdateProtocol {
    var title: Variable<String> { get }
    var firstname: Variable<String> { get }
    var lastname: Variable<String> { get }
    var phonenumber: Variable<String> { get }
    var submitButtonTapped: PublishSubject<Void> { get }
    var submitButtonEnabled: Observable<Bool> { get }
    var onNavigateBack: PublishSubject<Void>  { get }
    var onShowLoader: Observable<Bool> { get }
    //var onShowError: PublishSubject<SingleButtonAlert>  { get }
}

final class ContactUpdateViewModel: ContactUpdateProtocol {
    var title = Variable<String>("")
    var firstname = Variable<String>("")
    var lastname = Variable<String>("")
    var phonenumber = Variable<String>("")
    var contactId:Int?
    let onNavigateBack = PublishSubject<Void>()
    var submitButtonTapped = PublishSubject<Void>()
    let onShowError = PublishSubject<AlertContents>()
    private let serverManager: ServerManager
    private let disposeBag = DisposeBag()
    private let loader = Variable<Bool>(false)
    var onShowLoader: Observable<Bool> {
        return loader
            .asObservable()
            .distinctUntilChanged()
    }
    
    private var firstnameValid: Observable<Bool> {
        return firstname.asObservable().map { $0.count > 3 }
    }
    
    private var lastnameValid: Observable<Bool> {
        return lastname.asObservable().map { $0.count > 0 }
    }
    
    private var phoneNumberValid: Observable<Bool> {
        return phonenumber.asObservable().map { self.isValidPhone(phone: $0) }
    }
    
    var submitButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(firstnameValid, lastnameValid, phoneNumberValid) { $0 && $1 && $2 }
    }
    
    
    init(serverManager: ServerManager = ServerManager()) {
        title.value = "Add New Contact"
        self.serverManager = serverManager
        submitButtonTapped.subscribe(
            onNext: { [weak self] in
                self?.addContact()
            }
            ).disposed(by: disposeBag)
        
    }
    
    
    init(contactCellViewModel: ContactCellViewModel, serverManager: ServerManager = ServerManager()) {
        
        title.value = "Update Contact"
        self.firstname.value = contactCellViewModel.firstname
        self.lastname.value = contactCellViewModel.lastname
        self.phonenumber.value = contactCellViewModel.phonenumber
        self.contactId = contactCellViewModel.id
        self.serverManager = serverManager
        self.submitButtonTapped.asObserver().subscribe(onNext: { [weak self] in
            self?.updateContact()
        }).disposed(by: disposeBag)
    }
    
    
    func isValidPhone(phone: String) -> Bool {
        
        let phoneRegex = "[123456789][0-9]{9}";
        let valid = NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: phone)
        return valid
    }
    
    func addContact() {
        loader.value = true
        serverManager
            .addContact(firstname: firstname.value, lastname: lastname.value, phonenumber: phonenumber.value)
            .subscribe(
                onNext: {
                    [weak self] _ in
                    self?.loader.value = false
                    guard let `self` = self else {
                        return
                    }
                    
                    self.onNavigateBack.onNext(())
                },
                onError: {[weak self] error in
                    let okAlert = AlertContents(
                        title: "Failed to add information.",
                        message: (error as? ServerManager.FailureReason)?.getErrorMessage() ?? "Could not connect to server. Check your network and try again later.",
                        action: AlertAction(buttonTitle: "OK", handler: { })
                    )
                    self?.onShowError.onNext(okAlert)
                }
            ).disposed(by: disposeBag)
    }
    
    func updateContact() {
        loader.value = true
        serverManager
            .updateContact(firstname: firstname.value, lastname: lastname.value, phonenumber: phonenumber.value, id: contactId!)
            .subscribe(
                onNext: {
                    [weak self] _ in
                    self?.loader.value = false
                    guard let `self` = self else {
                        return
                    }
                    
                    self.onNavigateBack.onNext(())
                },
                onError: {[weak self] error in
                    let okAlert = AlertContents(
                        title: "Failed to update information.",
                        message: (error as? ServerManager.FailureReason)?.getErrorMessage() ?? "Could not connect to server. Check your network and try again later.",
                        action: AlertAction(buttonTitle: "OK", handler: { })
                    )
                    self?.onShowError.onNext(okAlert)
                }
            ).disposed(by: disposeBag)
    }
    
    
    
}


