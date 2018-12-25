//
//  ContactsTableViewModelTests.swift
//  PhoneDictionaryTests
//
//  Created by Pranalee Jadhav on 12/23/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import XCTest
import RxSwift
import RxTests

class ContactsTableViewModelTests: XCTestCase {
    private var disposeBage: Dis
    private var serverManager: ServerManager!

    
    override func setUp() {
        
        disposeBag = Dis
        serverManager = ServerManager()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_contacts_success() {
        
        serverManager.getContactsResult = .success(payload: [Contact.dummyContact()])
        
        let viewModel = ContactsTableViewModel(serverManager: serverManager)
        viewModel.getContacts()
        
        viewModel.contactCells
            .subscribe
        
    }

}
