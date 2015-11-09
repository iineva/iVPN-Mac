//
//  SeparatorView.swift
//  iVPN-Mac
//
//  Created by Steven on 15/11/7.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Cocoa

class SeparatorView: NSView {
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        
        NSColor.grayColor().colorWithAlphaComponent(0.3).set()
        
        NSRectFill(dirtyRect)
    }
    
}
