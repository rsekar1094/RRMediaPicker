//
//  File.swift
//  
//
//  Created by Raj S on 25/08/22.
//

import UIKit

// MARK: - MediaPickerController
public protocol MediaPickerController: MediaPicker {
    
    var mediaPickerPresentingController : UIViewController { get }
    
    func openImagePicker(for view : UIView,
                         title : String,
                         inputType : MediaPickerInputType,
                         additonalActions : [UIAlertAction])
}

// MARK: - MediaPickerController
public extension MediaPickerController where Self : UIViewController {
    var mediaPickerPresentingController : UIViewController { return self }
}

// MARK: - MediaPickerController + Picker
public extension MediaPickerController {
    
    func openImagePicker(for view : UIView,
                         title : String,
                         inputType : MediaPickerInputType,
                         additonalActions : [UIAlertAction] = []) {
        showGallerySelection(sourceView : view,
                             title: title,
                             additonalActions : additonalActions) { (type) in
            self.openPicker(source: type, inputType: inputType)
        }
    }
    
    func openPicker(source : MediaPickerSourceType,
                    inputType : MediaPickerInputType) {
        self.openMediaPicker(source: source,
                             inputType: inputType)
    }
}

// MARK: - Controller
private extension MediaPickerController {
    
    func showGallerySelection(sourceView : UIView,
                              title : String,
                              additonalActions : [UIAlertAction] = [],
                              completion : @escaping (MediaPickerSourceType) -> Void) {
        
        var actions : [UIAlertAction] = []
        actions.append(UIAlertAction(title: NSLocalizedString("Capture", comment: ""), style: .default, handler: { _ in
            self.mediaPickerPresentingController.view.endEditing(true)
            completion(.camera)
        }))
        
        actions.append(UIAlertAction(title: NSLocalizedString("Choose Photos", comment: ""), style: .default, handler: { _ in
            self.mediaPickerPresentingController.view.endEditing(true)
            completion(.gallery)
        }))
        
        actions.append(UIAlertAction(title: "Choose Documents", style: .default, handler: { _ in
            self.mediaPickerPresentingController.view.endEditing(true)
            completion(.document)
        }))
        
        actions.append(contentsOf: additonalActions)
        
        self.mediaPickerPresentingController.showActionSheet(title: nil,
                                                             message: nil,
                                                             actions: actions)
    }
    
    func openMediaPicker(source : MediaPickerSourceType,
                         inputType : MediaPickerInputType) {
       
        switch source {
        case .camera:
            mediaPermissionChecker(true) { [weak self] in
                guard let `self` = self else { return }
                
                self.mediaPickerPresentingController.present(self.getMediaController(source: source,
                                                                                inputType: inputType),
                                                             animated: true)
            }
        case .gallery:
            self.mediaPickerPresentingController.present(getMediaController(source: source,
                                                                            inputType: inputType),
                                                         animated: true)
        case .document:
            self.mediaPickerPresentingController.present(getMediaController(source: source,
                                                                            inputType: inputType),
                                                         animated: true)
        }
    }
    
}
