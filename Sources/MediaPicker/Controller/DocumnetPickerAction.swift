//
//  DocumnetPickerAction.swift
//  
//
//  Created by Raj S on 31/08/22.
//

import UIKit

// MARK: - MediaDocumnetPickerController
class MediaDocumnetPickerController: UIDocumentPickerViewController,
                                     UIDocumentPickerDelegate {
    
    var handleDocumentPickerSuccess: ((UIDocumentPickerViewController,[URL]) -> Void)?
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        handleDocumentPickerSuccess?(controller,urls)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
