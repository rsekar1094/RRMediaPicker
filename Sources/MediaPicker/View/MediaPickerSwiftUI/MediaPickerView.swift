//
//  File.swift
//  
//
//  Created by Raj S on 25/08/22.
//
import Foundation
import SwiftUI
import UIKit
import PhotosUI


public class MediaPickerViewModel: ObservableObject {
    
    public var sourceType: MediaPickerSourceType
    public let inputType: MediaPickerInputType
    public let selectionLimit: Int
    
    public init(sourceType: MediaPickerSourceType,
         inputType: MediaPickerInputType,
         selectionLimit: Int) {
        self.sourceType = sourceType
        self.inputType = inputType
        self.selectionLimit = selectionLimit
    }
    
}

public struct MediaPickerView: UIViewControllerRepresentable {
    
    var isPresenting: Binding<Bool>
    var isProcessing: Binding<Bool>
    let viewModel: MediaPickerViewModel
    let selection: ((MediaCapturedResult)->Void)?
   
    
    public init(isPresenting: Binding<Bool>,
                isProcessing: Binding<Bool>,
                viewModel: MediaPickerViewModel,
                selection: ((MediaCapturedResult) -> Void)?) {
        self.isPresenting = isPresenting
        self.isProcessing = isProcessing
        self.viewModel = viewModel
        self.selection = selection
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<MediaPickerView>) -> UIViewController {
        return context.coordinator.getMediaController(source: viewModel.sourceType,
                                                      inputType: viewModel.inputType)
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController,
                                context: UIViewControllerRepresentableContext<MediaPickerView>) {
        
    }
    
    public func makeCoordinator() -> MediaPickerCoordinator {
        MediaPickerCoordinator(self,
                               selectionLimit: viewModel.selectionLimit,
                               selection: selection)
    }
}


public final class MediaPickerCoordinator: NSObject,
                                           MediaPicker {
    public let selectionLimit: Int
    let selection: ((MediaCapturedResult)->Void)?
    var parent: MediaPickerView
    
    public init(_ parent: MediaPickerView,
                selectionLimit: Int,
                selection: ((MediaCapturedResult)->Void)?) {
        self.parent = parent
        self.selectionLimit = selectionLimit
        self.selection = selection
    }
    
    
    public func didCapturedMedia(result: MediaCapturedResult) {
        selection?(result)
        parent.isPresenting.wrappedValue = false
    }
    
    public func didMediaProcessingChange(isProcessing: Bool) {
        parent.isProcessing.wrappedValue = isProcessing
    }
}

