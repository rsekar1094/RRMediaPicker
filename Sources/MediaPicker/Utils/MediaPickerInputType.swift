//
//  MediaPickerInputType.swift
//  
//
//  Created by Raj S on 25/08/22.
//

import Foundation
import MobileCoreServices
import PhotosUI

// MARK: - Media Picker Item Type
public enum MediaPickerInputType {
    case video
    case image
    case bothImageAndVideo
    case imageAndDocument
    
    public var allowedUTTypes : [UTType] {
        switch self {
        case .video:
            return [UTType.mpeg4Movie,UTType.movie]
        case .image:
            return [UTType.png,UTType.jpeg,UTType.image]
        case .bothImageAndVideo:
            return [UTType.mpeg4Movie,UTType.movie,UTType.png,UTType.jpeg,UTType.image]
        case .imageAndDocument:
            return [UTType.png,UTType.jpeg,UTType.livePhoto,UTType.image,UTType.pdf]
        }
    }
    
    public var allowedFileTypes : [String] {
        switch self {
        case .video:
            return [AVFileType.mp4.rawValue,AVFileType.mov.rawValue]
        case .image:
            return [AVFileType.jpg.rawValue]
        case .bothImageAndVideo:
            return [AVFileType.jpg.rawValue,AVFileType.mp4.rawValue,AVFileType.mov.rawValue]
        case .imageAndDocument:
            return [AVFileType.jpg.rawValue,UTType.pdf.identifier]
        }
    }
    
    public var allowedPHFilters : [PHPickerFilter] {
        switch self {
        case .video:
            return [.videos]
        case .image:
            return [.images]
        case .bothImageAndVideo:
            return [.images,.videos]
        case .imageAndDocument:
            return [.images]
        }
    }
    
    public var allowedKUTTypes : [String] {
        switch self {
        case .video:
            return [UTType.mpeg4Movie.identifier,
                    UTType.movie.identifier]
        case .image:
            return [UTType.image.identifier]
        case .bothImageAndVideo:
            return [UTType.image.identifier,
                    UTType.mpeg4Movie.identifier,
                    UTType.movie.identifier]
        case .imageAndDocument:
            return [UTType.image.identifier,
                    UTType.pdf.identifier]
        }
    }
}
