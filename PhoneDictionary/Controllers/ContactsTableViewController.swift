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

class ContactsTableViewController: UITableViewController {

    let viewModel = ContactsTableViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        bindViewModel()
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
            .map { [weak self] in self?.showLoader(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
        
        
    }
    
    private func showLoader(visible: Bool) {
        visible ? SVProgressHUD.show() : SVProgressHUD.dismiss()
    }

   
}


extension ContactsTableViewController {
    func configureTableView() {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.tableView.tableFooterView = UIView()
    }
}
