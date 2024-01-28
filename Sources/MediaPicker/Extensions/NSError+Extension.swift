//
//  File.swift
//  
//
//  Created by Raj S on 25/08/22.
//

import Foundation

extension NSError {
    
    static var SOMETHING_WENT_WRONG_CODE : Int { return -302 }
    
    static var SOMETHING_WENT_WRONG : NSError {
        let error = NSError.init(domain: "app",
                                 code: SOMETHING_WENT_WRONG_CODE,
                                 userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Some thing went wrong.", comment: "")])
        return error
    }
}
