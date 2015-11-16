//
//  ServerTableCellView.swift
//  iVPN-Mac
//
//  Created by Steven on 15/11/7.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Cocoa

class ServerTableCellView: NSTableCellView {
    
    
    @IBOutlet weak var iconImageView: NSImageView!
    
    @IBOutlet weak var titleLab: NSTextField!
    
    @IBOutlet weak var subTitleLab: NSTextField!
    
    @IBOutlet weak var connected: NSButton!
}