//
//  MainWindowController.swift
//  iVPN-Mac
//
//  Created by Steven on 15/11/7.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    override func windowDidLoad() {
        super.windowDidLoad()
        configureWindowAppearance()
    }

    private func configureWindowAppearance() {
        if let window = window {
            window.styleMask |= NSFullSizeContentViewWindowMask
            window.titleVisibility = .Hidden
            window.titlebarAppearsTransparent = true
        }
    }

}
