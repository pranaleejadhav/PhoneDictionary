//
//  AddContactViewController.swift
//  PhoneDictionary
//
//  Created by Pranalee Jadhav on 12/23/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt
import SVProgressHUD

class AddContactViewController: UIViewController, ShowAlertProtocol {

    @IBOutlet weak var textFieldFirstname: UITextField!
    @IBOutlet weak var textFieldLastname: UITextField!
    @IBOutlet weak var textFieldPhoneNumber: UITextField!
    @IBOutlet weak var buttonSubmit: UIButton!
    
    var viewModel = ContactUpdateViewModel()
    var updateContacts = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.updateContacts.onCompleted()
        super.viewWillDisappear(animated)
    }
    
    func bindViewModel() {
        
        self.title = viewModel.title.value
        bind(textField: textFieldFirstname, to: viewModel.firstname)
        bind(textField: textFieldLastname, to: viewModel.lastname)
        bind(textField: textFieldPhoneNumber, to: viewModel.phonenumber)
        
        viewModel.submitButtonEnabled.bind(to: buttonSubmit.rx.isEnabled).disposed(by: disposeBag)
        
        buttonSubmit.rx.tap.asObservable()
            .bind(to: viewModel.submitButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel
            .onShowError
            .map { [weak self] in self?.showAlertDialog(alert: $0)}
            .subscribe()
            .disposed(by: disposeBag)
        
        viewModel.onShowLoader
            .map { [weak self] in self?.showLoader(visible: $0) }
            .subscribe(
            
            )
            .disposed(by: disposeBag)
        
        viewModel
            .onNavigateBack
            .asObservable()
            .subscribe(
                onNext: { [weak self] in
                    print("next triggered")
                    self?.updateContacts.onNext(())
                    self?.navigationController?.popViewController(animated: true)
                }
            ).disposed(by: disposeBag)
        
    }
    
    private func showLoader(visible: Bool) {
        visible ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }

    
    private func bind(textField: UITextField, to variable: Variable<String>) {
        variable.asObservable()
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        textField.rx.text.unwrap() /* The `unwrap` operator takes a sequence of optional elements
        and returns a sequence of non-optional elements, filtering out any `nil` values.*/

            .bind(to: variable)
            .disposed(by: disposeBag)
    }

}
