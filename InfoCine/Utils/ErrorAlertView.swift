//
//  ErrorAlertView.swift
//  InfoCine
//
//  Created by Jad Messadi on 6/5/21.
//

import UIKit

func showErrorAlertView(title: String, body: String) {
    let controller = UIAlertController(title: title, message: body, preferredStyle: .alert)
    let ok = UIAlertAction(title: NSLocalizedString("OK_BUTTON", comment: ""), style: .default, handler: nil)
    controller.addAction(ok)
    if let viewController = Application.window!.rootViewController {
        viewController.present(controller, animated: true, completion: nil)
    }
}


