//
//  File.swift
//  
//
//  Created by Raj S on 25/08/22.
//

import Foundation

public extension URL {
    var isImage : Bool {
        return ["png", "jpg", "gif","jpeg"].contains(self.pathExtension.lowercased())
    }
    
    var isVideo : Bool {
        return ["mov", "mp4", "avi","mkv"].contains(self.pathExtension.lowercased())
    }
    
    var isPdf : Bool {
        return ["pdf"].contains(self.pathExtension.lowercased())
    }
}
