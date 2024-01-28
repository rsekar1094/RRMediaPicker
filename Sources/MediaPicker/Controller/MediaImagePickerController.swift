//
//  File.swift
//  
//
//  Created by Raj S on 31/08/22.
//

import UIKit

// MARK: - MediaImagePickerController
class MediaImagePickerController: UIImagePickerController,
                                  UIImagePickerControllerDelegate,
                                  UINavigationControllerDelegate {
    
    var handleImagePickerSuccess: ((UIImagePickerController,[UIImagePickerController.InfoKey : Any]) -> Void)?
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        handleImagePickerSuccess?(picker,info)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
