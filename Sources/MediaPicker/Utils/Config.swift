//
//  File.swift
//  
//
//  Created by Raj S on 25/08/22.
//

import UIKit

/// IsCamera - Bool
public var mediaPermissionChecker: ((Bool, (() -> Void)?) -> Void) = { isCamera,completion in
    completion?()
}
