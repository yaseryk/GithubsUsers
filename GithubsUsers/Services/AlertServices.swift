//
//  AlertServices.swift
//  GithubsUsers
//
//  Created by Yaser on 7/11/21.
//

import UIKit

struct AlertServices {
    static func showAlert( _ message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
