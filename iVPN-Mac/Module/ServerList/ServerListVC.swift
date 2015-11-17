//
//  ServerListVC.swift
//  iVPN-Mac
//
//  Created by Steven on 15/11/7.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Cocoa
import SwiftyJSON
import AlamofireImage
import NetworkExtension

class ServerListVC: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    
    var currentConnected: ServerInfo?
    
    var loginInfo: LoginInfo? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 发起登录请求获取服务器列表
        $.login {
            [weak self] info -> Void in
            self?.loginInfo = info
        }
    }
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if let array = loginInfo?.servergroup {
            return array.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = tableView.makeViewWithIdentifier("cell", owner: tableView) as? ServerTableCellView
        
        if let info = self.loginInfo?.servergroup?[row] {
            cell?.titleLab.stringValue = info.groupname ?? "-"
            cell?.subTitleLab.stringValue = info.englishname ?? "-"
            cell?.iconImageView.af_setImage(URL: info.image ?? "")
            cell?.connected.enabled = currentConnected == info
        }
        
        return cell
    }
    
    func tableView(tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        
        return false
        
        // 点击连接VPN
        if let info = loginInfo?.servergroup?[row] {
            
            if let host = info.nas?.first {
                
                if let userInfo = loginInfo?.info {
                    
                    let p = NEVPNProtocolIPSec(
                        host: host.nasname!,
                        userName: userInfo.username!,
                        password: userInfo.password!,
                        sharedSecret: $.kTianxingSharedSecret)
                    
                    NEVPNManager.sharedManager().connect("iVPN", protocolConfiguration: p) {
                        
                        [weak self] (error) -> Void in
                        
                        if error != nil {
                            // TODO 提示错误
                            print("连接失败了!!!!")
                        } else {
                            self?.currentConnected = info
                            self?.tableView.reloadData()
                            print("Connected!!!")
                        }
                    }
                    
                }
                
            }
        }
        
        return false
    }
    
}