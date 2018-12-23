//
//  ShowAlertHelper.swift
//  PhoneDictionary
//
//  Created by Pranalee Jadhav on 12/23/18.
//  Copyright © 2018 Pranalee Jadhav. All rights reserved.
//

import UIKit

struct AlertContents {
    let title: String
    let message: String?
    let action: AlertAction
}

struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
}


protocol ShowAlertProtocol {
    func showAlertDialog(alert: AlertContents)
}

extension ShowAlertProtocol where Self: UIViewController {
    func showAlertDialog(alert: AlertContents) {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: alert.action.buttonTitle,
                                                style: .default,
                                                handler: { _ in alert.action.handler?() }))
        self.present(alertController, animated: true, completion: nil)
    }
}

