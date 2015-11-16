//
//  NSView.swift
//  iVPN-Mac
//
//  Created by Steven on 15/11/7.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Cocoa
import Alamofire

extension NSView {
    
    private struct AssociatedKeys {
        static var ImageCurrentRequestKey = "af_NSView.ImageCurrentRequestKey"
    }
    
    var __af_currentRequest: Request? {
        
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.ImageCurrentRequestKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        get {
            if let request = objc_getAssociatedObject(self, &AssociatedKeys.ImageCurrentRequestKey) as? Request {
                return request
            } else {
                return nil
            }
        }
    }
    
}
