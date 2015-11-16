//
//  VPNHelper.swift
//  VPNTest
//
//  Created by Steven on 15/9/29.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Foundation
import NetworkExtension

private class KeyChain {
    
    class func getDataWithKey(key: String) -> NSData? {
        
        let keychainQuery: [NSObject: AnyObject] =  [
            kSecClass : kSecClassGenericPassword,
            kSecAttrGeneric : key,
            kSecAttrAccount : key,
            kSecAttrService : NSBundle.mainBundle().bundleIdentifier ?? "",
            kSecAttrAccessible: kSecAttrAccessibleAlwaysThisDeviceOnly,
            kSecMatchLimit : kSecMatchLimitOne,
            kSecReturnPersistentRef : kCFBooleanTrue]
        
        var retrievedData: NSData?
        var extractedData: AnyObject?
        let status = SecItemCopyMatching(keychainQuery, &extractedData)
        
        if (status == errSecSuccess) {
            retrievedData = extractedData as? NSData
        } else {
            print("Unable to fetch item for key = \(key) with error:\(status)")
        }
        
        return retrievedData
    }
    
    class func storeString(string: String, key: String) -> OSStatus {
        let keychainQuery: [NSObject: AnyObject] =  [
            kSecClass : kSecClassGenericPassword,
            kSecAttrGeneric : key,
            kSecAttrAccount : key,
            kSecAttrService : NSBundle.mainBundle().bundleIdentifier ?? "",
            kSecAttrAccessible: kSecAttrAccessibleAlwaysThisDeviceOnly,
            kSecValueData : string.dataUsingEncoding(NSUTF8StringEncoding) ?? ""]
        
        SecItemDelete(keychainQuery)
        
        let status = SecItemAdd(keychainQuery, nil)
        if (status != errSecSuccess) {
            print("Unable add item with key = \(key) error: \(status)")
        }
        
        return status
    }
    
    /// 保存字符串，并获取keychain中的data
    class func storeStringAndGetData(string: String, key: String) -> NSData? {
        self.storeString(string, key: key)
        return self.getDataWithKey(key)
    }
    
}


extension NEVPNManager {
    
    /**
     连接一个VPN
     
     - parameter localizedDescription: VPN连接的标题
     - parameter protocolObject:       VPN连接配置
     - parameter complete:             完成回调
     */
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
                self?.onDemandEnabled = false // 按需启动
                
                // 设置连接规则
                var  rules = [NEOnDemandRuleConnect]()
                
                // 允许使用wifi数据流量
                let rule1 = NEOnDemandRuleConnect();
                rule1.interfaceTypeMatch = NEOnDemandRuleInterfaceType.WiFi
                rules.append(rule1)
                
                
                let rule2 = NEOnDemandRuleConnect();
                #if os(iOS)
                    // 允许使用蜂窝移动数据流量
                    rule2.interfaceTypeMatch = NEOnDemandRuleInterfaceType.Cellular
                #elseif os(OSX)
                    // 允许使用网卡数据流量
                    rule2.interfaceTypeMatch = NEOnDemandRuleInterfaceType.Ethernet
                #endif
                rules.append(rule2)
                
                
                self?.onDemandRules = rules
                
                // 保存配置到系统，会提示用户，跳转到设置页确认
                self?.saveToPreferencesWithCompletionHandler({ (e: NSError?) -> Void in
                    // 保存后回调
                    if error != nil {
                        print("Save Error: \(e)")
                        complete(error: NEVPNError.ConfigurationReadWriteFailed)
                    } else {
                        print("Saved!")
                        print("Connect Start...")
                        
                        self?.loadFromPreferencesWithCompletionHandler({ (e) -> Void in
                            do {
                                try self?.connection.startVPNTunnel()
                                print("Connect Started!!")
                                complete(error: nil)
                            } catch {
                                print("Connect Error: \(error)")
                                complete(error: NEVPNError.ConnectionFailed)
                            }
                        })
                    }
                })
            }
        }
    }
}


let kUserPassword = "cn.ineva.VPNHelper.kUserPassowrd"
let kSharedSecret = "cn.ineva.VPNHelper.kSharedSecret"

extension NEVPNProtocolIPSec {
    
    public convenience init(host: String, userName user: String, password: String, sharedSecret: String, localIdentifier: String? = nil, remoteIdentifier: String? = nil ) {
        self.init()
        self.username               = user
        self.serverAddress          = host
        self.passwordReference      = KeyChain.storeStringAndGetData(password, key: kUserPassword)
        self.sharedSecretReference  = KeyChain.storeStringAndGetData(sharedSecret, key: kSharedSecret)
        self.authenticationMethod   = NEVPNIKEAuthenticationMethod.SharedSecret
        self.localIdentifier        = localIdentifier ?? "vpn"
        self.remoteIdentifier       = remoteIdentifier ?? "vpn"
        self.disconnectOnSleep      = false
        self.useExtendedAuthentication = true
    }
}
