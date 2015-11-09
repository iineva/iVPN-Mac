//
//  ServerListViewController.swift
//  iVPN-Mac
//
//  Created by Steven on 15/11/7.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Cocoa
import SwiftyJSON
import AlamofireImage
import NetworkExtension

class ServerListViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView!
    
    var manager: VCIPsecVPNManager?
    
    var currentConnected: ServerInfo?
    
    var loginInfo: LoginInfo? {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        $.login {
//            [weak self] info -> Void in
//            self?.loginInfo = info
//        }
        
        // for test
        if let jsonPath = NSBundle.mainBundle().pathForResource("login", ofType: "json") {
            if let data = NSData(contentsOfFile: jsonPath) {
                
                let dic = JSON(data: data).dictionaryObject
                
                loginInfo = LoginInfo( dictionary: dic )
            }
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
        
        // 点击连接VPN
        if let info = loginInfo?.servergroup?[row] {
            if let host = info.nas?.first {
                
                manager = VCIPsecVPNManager()
                
                manager?.connectIPSecWithHost("cn7.yunfv.com", andUsername: "2294411486", andPassword: "149986", andPSK: "123456", andGroupName: "cn.ineva.local")
                
                return false
                
                // TODO 连接Host
                
                if let userInfo = loginInfo?.info {
                 
//                    let p = NEVPNProtocolIPSec(
//                        userName: userInfo.username!,
//                        password: userInfo.password!,
//                        serverAddress: host.nasname!,
//                        sharedSecret: "txvpn",
//                        localIdentifier: "cn.ineva.local",
//                        remoteIdentifier: "cn.ineva.remote")
                    let p = NEVPNProtocolIPSec(
                        userName: "2294411486",
                        password: "149986",
                        serverAddress: "cn7.yunfv.com",
                        sharedSecret: "123456",
                        localIdentifier: "cn.ineva.local",
                        remoteIdentifier: "cn.ineva.remote")
                    
                    NEVPNManager.sharedManager().connect("iNeva VPN", protocolConfiguration: p) {
                        
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