//
//  MediaCapturedResult.swift
//  
//
//  Created by Raj S on 25/08/22.
//

import Foundation

// MARK: - MediaPickerProtocol
public class MediaCapturedResult {
    public var videos : [URL]
    public var images : [URL]
    public var documents: [URL]
    
    // if there is any error while decoding will present here
    public var errors : [Error] = []
    
    public var totalItemCount : Int { return videos.count + images.count + documents.count }
    
    init(videos : [URL] = [],
         images : [URL] = [],
         documents: [URL] = []) {
        self.images = images
        self.videos = videos
        self.documents = documents
    }
}
