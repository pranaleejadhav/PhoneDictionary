//
//  ContactsTableViewModel.swift
//  PhoneDictionary
//
//  Created by Pranalee Jadhav on 12/23/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import RxSwift

enum ContactTableViewCellType {
    case normal(cellViewModel: ContactCellViewModel)
    case error(message: String)
    case empty
}

class ContactsTableViewModel {
    //two way binding. Bind viewModel to model (using server manager) and bind viewmodel to tableview cells
    
    private let serverManager: ServerManager
    private let disposeBag = DisposeBag()
    private let observableCells = Variable<[ContactTableViewCellType]>([])
    var contactCells: Observable<[ContactTableViewCellType]> {
        return observableCells.asObservable()
    }
    private var loader = Variable<Bool>(false)
    var onShowLoader: Observable<Bool> {
        return loader.asObservable().distinctUntilChanged()
        
    }
    
    init(serverManager: ServerManager = ServerManager()) {
        self.serverManager = serverManager
    }
    
    
    func getContacts() {
        loader.value = true
        serverManager
            .getContacts()
            .subscribe(
                onNext: { [weak self] contacts in
                    self?.loader.value = false
                    
                    guard contacts.count > 0 else {
                        self?.observableCells.value = [.empty]
                        return
                    }
                    self?.observableCells.value = contacts.compactMap{ .normal(cellViewModel: ContactCellViewModel(contact: $0))}
                },
                onError: { [weak self] error in
                    self?.loader.value = false
                   let message = (error as? ServerManager.FailureReason)?.getErrorMessage() ?? "Error Ocurred. Please try again"
                    self?.observableCells.value = [.error(message: message)]
                }
            )
            .disposed(by: disposeBag)
    }
    
}

extension ServerManager.FailureReason {
    func getErrorMessage() -> String? {
        switch self {
        case .unAuthorized:
            return "Please login to load your friends."
        case .notFound:
            return "Could not complete request, please try again."
        }
    }
}
