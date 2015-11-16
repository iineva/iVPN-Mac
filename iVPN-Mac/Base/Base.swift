//
//  Base.swift
//  iVPN-Mac
//
//  Created by Steven on 15/11/5.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Cocoa

class $ {
    
    // 服务器IP
    static var loginServerIP: String?
    
    static let platform = "iPhone7,2"
    static let system = "9.0.2"
    static let kTianxingSharedSecret = "xsky"
    
    private static var UUIDStore: String?
    static var UUID: String {
        
        if UUIDStore == nil {

            let task = NSTask()
            let args = ["-rd1", "-c", "IOPlatformExpertDevice", "|", "grep", "model"]
            let pipe = NSPipe()
            
            task.launchPath = "/usr/sbin/ioreg"
            task.arguments = args
            task.standardOutput = pipe
            task.launch()
            
            
            let task2 = NSTask()
            let args2 = ["/IOPlatformUUID/ { split($0, line, \"\\\"\"); printf(\"%s\\n\", line[4]); }"]
            let pipe2 = NSPipe()
            
            task2.launchPath = "/usr/bin/awk"
            task2.arguments = args2
            task2.standardInput = pipe
            task2.standardOutput = pipe2
            task2.launch()
            
            let fileHandle2 = pipe2.fileHandleForReading
            let data = fileHandle2.readDataToEndOfFile
            
            UUIDStore = String(data: data(), encoding: NSUTF8StringEncoding)?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            print(UUIDStore)
        }
        
        return UUIDStore ?? "Unkonw UUID";
    }
}