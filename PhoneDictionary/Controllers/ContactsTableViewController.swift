//
//  ContactsTableViewController.swift
//  PhoneDictionary
//
//  Created by Pranalee Jadhav on 12/23/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import SVProgressHUD

class ContactsTableViewController: UITableViewController, ShowAlertProtocol {

    let viewModel = ContactsTableViewModel()
    private let disposeBag = DisposeBag()
    private var selectedContact: ContactCellViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bindViewModel()
        setUpCellDeleting()
        setUpOnCellSelect()
        viewModel.getContacts()
        
    }

    func bindViewModel() {
        
        viewModel.contactCells.bind(to: tableView.rx.items) { tableView, index, element in
            let indexPath = IndexPath(item: index, section: 0)
            switch(element) {
                case .normal(let viewModel):
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as? ContactTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.viewModel = viewModel
                    return cell
                case .error(let error):
                        let cell = UITableViewCell()
                        cell.textLabel?.text = error
                        cell.isUserInteractionEnabled = false
                        return cell
                case .empty:
                    let cell = UITableViewCell()
                    cell.textLabel?.text = "No Contacts Found."
                    cell.isUserInteractionEnabled = false
                    return cell
                }
        }.disposed(by: disposeBag)
        
        viewModel
            .onShowLoader
            //.map { [weak self] in self?.showLoader(visible: $0) }
            .subscribe(
                onNext: { [weak self] in self?.showLoader(visible: $0)})
            .disposed(by: disposeBag)
        
        viewModel
            .onShowError
            .map { [weak self] in self?.showAlertDialog(alert: $0)}
            .subscribe()
            .disposed(by: disposeBag)
  
    }
  
    func setUpCellDeleting() {
        
        tableView.rx
            .modelDeleted(ContactTableViewCellType.self)
            .subscribe(
                onNext: { [weak self] contactCellType in
                    if case let .normal(cellViewModel) = contactCellType {
                        self?.viewModel.deleteContact(contact: cellViewModel)
                    }
                    if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                        self?.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
            }).disposed(by: disposeBag)
        
    }
    
    func setUpOnCellSelect() {
        tableView.rx
            .modelSelected(ContactTableViewCellType.self)
            .subscribe(
                onNext: { [weak self] contactCell in
                    if case let .normal(viewModel) = contactCell {
                        self?.selectedContact = viewModel
                        self?.performSegue(withIdentifier: "updateContactSegue", sender: self)
                    }
                    if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                        self?.tableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func showLoader(visible: Bool) {
        visible ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addContactSegue",
            let destinationViewController = segue.destination as? AddContactViewController
        {
            destinationViewController.viewModel = ContactUpdateViewModel()
            destinationViewController.updateContacts.asObserver().subscribe(onNext: { [weak self] () in
                print("next received1")
                self?.viewModel.getContacts()
                }, onCompleted: {
                    print("ONCOMPLETED")
            }).disposed(by: destinationViewController.disposeBag)
        } else if segue.identifier == "updateContactSegue",
            let destinationViewController = segue.destination as? AddContactViewController,
            let viewModel = selectedContact
            {
                destinationViewController.viewModel = ContactUpdateViewModel(contactCellViewModel: viewModel)
                destinationViewController.updateContacts.asObserver().subscribe(onNext: { [weak self] () in
                    print("next received")
                    self?.viewModel.getContacts()
                    }, onCompleted: {
                        print("ONCOMPLETED")
                }).disposed(by: destinationViewController.disposeBag)
        }
    }
   
}


extension ContactsTableViewController {
    func configureTableView() {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.tableView.tableFooterView = UIView()
    }
}
