//
//  PlatformListVC.swift
//  iVPN-Mac
//
//  Created by Steven on 15/11/5.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Cocoa

class PlatformListVC: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate {

    @IBOutlet weak var outlineView: NSOutlineView!
    
    let dataItems = ["Tianxing(天行)", "VPN Gate"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        
        let cell = outlineView.makeViewWithIdentifier("DataCell", owner: self) as! NSTableCellView
        let info = item as? String
        cell.textField?.stringValue = info ?? "-"
        return cell
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return false
    }
    func outlineView(outlineView: NSOutlineView, isGroupItem item: AnyObject) -> Bool {
        return false
    }
    func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
        return true
    }
    func outlineViewSelectionDidChange(notification: NSNotification) {
        // TODO
    }
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        return dataItems[index]
    }
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        // The root item has each collection as its children.
        if item == nil {
            return 0
            return dataItems.count
        } else {
            return 0
        }
    }
}