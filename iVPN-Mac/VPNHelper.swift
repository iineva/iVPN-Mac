//
//  VPNHelper.swift
//  VPNTest
//
//  Created by Steven on 15/9/29.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Foundation
import NetworkExtension

@available(iOS 8.0, *)
extension NEVPNManager {
    
    /**
    连接一个VPN
    
    - parameter localizedDescription: VPN连接的标题
    - parameter protocolObject:       VPN连接配置
    - parameter complete:             完成回调
    */
    @available(iOS 8.0, *)
    func connect(localizedDescription: String?, protocolConfiguration: NEVPNProtocol, complete: (error: NEVPNError?) -> Void ) {
        
        self.loadFromPreferencesWithCompletionHandler {
            [weak self](error: NSError?) -> Void in
            
            if error != nil {
                print("Load error: \(error)");
                complete(error: NEVPNError.ConfigurationReadWriteFailed)
            } else {
                
                self?.`protocol` = protocolConfiguration
                self?.localizedDescription = localizedDescription
                self?.enabled = true
                
//                self?.onDemandEnabled = false // 按需启动
//                 设置某个东西？？？
//                var rules = [NEOnDemandRuleConnect]()
//                let connectRule = NEOnDemandRuleConnect();
//                rules.append(connectRule)
//                self?.onDemandRules = rules
                
                // 保存配置到系统，会提示用户，跳转到设置页确认
                self?.saveToPreferencesWithCompletionHandler({ (e: NSError?) -> Void in
                    // 保存后回调
                    if error != nil {
                        print("Save Error: \(e)")
                        complete(error: NEVPNError.ConfigurationReadWriteFailed)
                    } else {
                        print("Saved!")
                        print("Connect Start...")
                        do {
                            try self?.connection.startVPNTunnel()
                            print("Connect Success!!")
                            complete(error: nil)
                        } catch {
                            print("Connect Error: \(error)")
                            complete(error: NEVPNError.ConnectionFailed)
                        }
                    }
                })
            }
        }
    }
}

extension NEVPNProtocolIPSec {
    
    public convenience init(userName user: String, password: String?, serverAddress: String, sharedSecret: String?, localIdentifier: String?, remoteIdentifier: String? ) {
        
        print(password?.dataUsingEncoding(NSUTF8StringEncoding))
        
        self.init()
        self.username               = user
        self.passwordReference      = password?.dataUsingEncoding(NSUTF8StringEncoding)
        self.serverAddress          = serverAddress
        self.authenticationMethod   = NEVPNIKEAuthenticationMethod.SharedSecret
        self.sharedSecretReference  = sharedSecret?.dataUsingEncoding(NSUTF8StringEncoding)
        self.localIdentifier        = localIdentifier
        self.remoteIdentifier       = remoteIdentifier
        self.useExtendedAuthentication = true
        self.disconnectOnSleep      = false
    }
}
