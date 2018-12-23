//
//  ContactTableViewCell.swift
//  PhoneDictionary
//
//  Created by Pranalee Jadhav on 12/23/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelPhoneNumber: UILabel!
    
    var viewModel: ContactCellViewModel? {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        if let viewModel = viewModel {
            labelFullName?.text = "\(viewModel.firstname) \(viewModel.lastname)"
            labelPhoneNumber?.text = viewModel.phonenumber
        }
    }
   

}
