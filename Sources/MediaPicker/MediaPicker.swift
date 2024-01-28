//
//  File.swift
//  
//
//  Created by Raj S on 24/08/22.
//

import Foundation
import MobileCoreServices
import PhotosUI

// MARK: - MediaPickerSourceType
public enum MediaPickerSourceType {
    case camera
    case gallery
    case document
}

// MARK: - MediaPicker
public protocol MediaPicker: PHPickerViewControllerDelegate {
    
    // pass 0 for infinite
    var selectionLimit : Int { get }
    
    func didCapturedMedia(result : MediaCapturedResult)
    
    func didMediaProcessingChange(isProcessing: Bool)
    
    func didSelectedAMedia()
}

public extension MediaPicker {
    
    var needToCompress: Bool { return true }
    
    func getMediaController(source : MediaPickerSourceType,
                            inputType : MediaPickerInputType) -> UIViewController {
        switch source {
        case .gallery:
            var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
            
            // Specify type of media to be filtered or picked. Default is all
            configuration.filter = .any(of: inputType.allowedPHFilters)
            configuration.preferredAssetRepresentationMode = .current
            
            
            // For unlimited selections use 0. Default is 1
            configuration.selectionLimit = self.selectionLimit
            
            // Create instance of PHPickerViewController
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            return picker
        case .camera:
            let isCamera = true
            let imagePicker = MediaImagePickerController()
            imagePicker.mediaTypes = inputType.allowedKUTTypes
            imagePicker.delegate = imagePicker
            imagePicker.allowsEditing = false
            imagePicker.videoQuality = .typeHigh
            imagePicker.videoExportPreset = AVAssetExportPresetHighestQuality
            imagePicker.sourceType = isCamera ? .camera : .photoLibrary
            imagePicker.modalPresentationStyle = isCamera ? .fullScreen : .formSheet
            imagePicker.handleImagePickerSuccess = { [weak self] controller,info in
                guard let `self` = self else { return }
                self.handleImagePickerSuccess(controller, didFinishPickingMediaWithInfo: info)
            }
            return imagePicker
        case .document:
            let pickerVC = MediaDocumnetPickerController(forOpeningContentTypes: inputType.allowedUTTypes,
                                                          asCopy: false)
            pickerVC.delegate = pickerVC
            pickerVC.handleDocumentPickerSuccess = { [weak self] controller,urls in
                guard let `self` = self else { return }
                
                self.handleDocumentPickerSuccess(controller, didPickDocumentsAt: urls)
            }
            return pickerVC
        }
    }
    
    func deleteAllTemporaryFiles(from result : MediaCapturedResult) {
        var urls = result.images
        urls.append(contentsOf: result.videos)
        
        for url in urls {
            ///delete the temporary directory file
            if let _ = url.pathComponents.first(where: { $0.lowercased() == "temp" }) {
                try? FileManager.default.removeItem(at: url)
            }
        }
    }
    
    func didSelectedAMedia() {}
    
}

// MARK: - UIImagePicker + UIDocument Picker
public extension MediaPicker {
    
    func handleImagePickerSuccess(_ picker: UIImagePickerController,
                                  didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true,
                       completion: { [weak self] in
            guard let `self` = self else {
                return
            }
            
            if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                self.didCapturedMedia(result: MediaCapturedResult(videos: [url]))
            } else if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                var url = FileManager.default.temporaryDirectory
                url.appendPathComponent("\(UUID.init().uuidString).png")
                try? FileManager.default.removeItem(at: url)
                try? pickedImage.pngData()?.write(to: url)
                
                self.didMediaProcessingChange(isProcessing: false)
                self.didCapturedMedia(result: MediaCapturedResult(images: [url]))
            }
            
        })
    }
    
    
    func handleDocumentPickerSuccess(_ controller: UIDocumentPickerViewController,
                                     didPickDocumentsAt urls: [URL]) {
        let result = MediaCapturedResult()
        
        for url in urls {
            var tempDirectory = FileManager.default.temporaryDirectory
            tempDirectory.appendPathComponent(url.lastPathComponent)
            try? FileManager.default.removeItem(at: tempDirectory)
            
            let isSecuredURL = url.startAccessingSecurityScopedResource() == true
            try? FileManager.default.copyItem(at: url, to: tempDirectory)
            
            if isSecuredURL {
                url.stopAccessingSecurityScopedResource()
            }
            
            if tempDirectory.isPdf {
                result.documents.append(tempDirectory)
            } else if tempDirectory.isImage {
                result.images.append(tempDirectory)
            } else {
                result.videos.append(tempDirectory)
            }
        }
        
        self.didMediaProcessingChange(isProcessing: false)
        didCapturedMedia(result: result)
    }
    
}


public extension MediaPicker {
    
    func picker(_ picker: PHPickerViewController,
                didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true, completion: { [weak self] in
            guard let `self` = self,
                  !results.isEmpty else {
                return
            }
            
            self.didSelectedAMedia()
            self.didMediaProcessingChange(isProcessing: true)
            
            let result = MediaCapturedResult()
            let totalCount = results.count
            var completedCount = 0
            
            func checkIsCompleted() {
                if totalCount == completedCount {
                    DispatchQueue.main.async {
                        self.didMediaProcessingChange(isProcessing: false)
                        self.didCapturedMedia(result: result)
                    }
                }
            }
            
            for item in results {
                let prov = item.itemProvider
                
                if prov.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    self.processMovie(for: prov) { response in
                        switch response {
                        case .success(let url):
                            result.videos.append(url)
                        case .failure(let error):
                            result.errors.append(error)
                        }
                        
                        completedCount += 1
                        checkIsCompleted()
                        
                    }
                } else {
                    let type: UTType
                    if prov.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                        type = .image
                    } else if prov.hasItemConformingToTypeIdentifier(UTType.png.identifier) {
                        type = .png
                    } else if prov.hasItemConformingToTypeIdentifier(UTType.heic.identifier) {
                        type = .heic
                    } else if prov.hasItemConformingToTypeIdentifier(UTType.jpeg.identifier) {
                        type = .jpeg
                    } else {
                        completedCount += 1
                        checkIsCompleted()
                        return
                    }
                    
                    self.processImage(for: prov,type: type) { response in
                        switch response {
                        case .success(let url):
                            result.images.append(url)
                        case .failure(let error):
                            result.errors.append(error)
                        }
                        
                        completedCount += 1
                        checkIsCompleted()
                    }
                }
                
            }
            
        })
        
    }
}


private extension MediaPicker {
    
    func processMovie(for provider: NSItemProvider,
                      compltion: @escaping ((Result<URL,Error>) -> Void)) {
        let movie = UTType.movie.identifier
        provider.loadFileRepresentation(forTypeIdentifier: movie) { url, err in
            
            guard let url = url else {
                compltion(.failure(err ?? NSError.SOMETHING_WENT_WRONG))
                return
            }
            
            let secureAccess = url.startAccessingSecurityScopedResource()
            
            defer {
                if secureAccess {
                    url.stopAccessingSecurityScopedResource()
                }
            }
            
            var copiedUrl = FileManager.default.temporaryDirectory
            copiedUrl.appendPathComponent(url.lastPathComponent)
            try? FileManager.default.removeItem(at: copiedUrl)
            
            do {
                try FileManager.default.copyItem(at: url, to: copiedUrl)
                compltion(.success(copiedUrl))
            } catch let error {
                compltion(.failure(error))
            }
            
        }
    }
    
    func processImage(for provider: NSItemProvider,
                      type: UTType,
                      compltion: @escaping ((Result<URL,Error>) -> Void)) {
        provider.loadFileRepresentation(forTypeIdentifier: type.identifier,
                                        completionHandler: {url,err in
            guard let outputurl = url else {
                compltion(.failure(err ?? NSError.SOMETHING_WENT_WRONG))
                return
            }
            
            let secureAccess = outputurl.startAccessingSecurityScopedResource()
            
            defer {
                if secureAccess {
                    outputurl.stopAccessingSecurityScopedResource()
                }
            }
            
            guard let data = try? Data(contentsOf: outputurl) else  {
                compltion(.failure(err ?? NSError.SOMETHING_WENT_WRONG))
                return
            }
            
            var url = FileManager.default.temporaryDirectory
            url.appendPathComponent("\(UUID.init().uuidString).png")
            try? FileManager.default.removeItem(at: url)
            
            autoreleasepool {
                do {
                    try data.write(to: url)
                    compltion(.success(url))
                } catch let error {
                    compltion(.failure(error))
                }
            }
            
        })
    }
}
