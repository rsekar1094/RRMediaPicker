//
//  File.swift
//  
//
//  Created by Raj S on 25/08/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showActionSheet(title : String? = nil,
                         message : String? = nil,
                         actions : [UIAlertAction],
                         cancelAction: (()->Void)? = nil) {
        let alertController : UIAlertController
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        } else {
            alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        }
        
        actions.forEach { action in
            alertController.addAction(action)
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            alertController.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .destructive, handler: { _ in
                cancelAction?()
            }))
        } else {
            let cancel = UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (_) in
                cancelAction?()
            })
            cancel.setValue(UIColor.red, forKey: "titleTextColor")
            alertController.addAction(cancel)
        }
        
        alertController.popoverPresentationController?.sourceView = self.view
        alertController.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.midX,
                                                                           y: self.view.frame.midY, width: 0, height: 0)
        self.present(alertController, animated: true, completion: nil)
    }
}
