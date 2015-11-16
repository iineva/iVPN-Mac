//
//  Model.swift
//  iVPN-Mac
//
//  Created by Steven on 15/11/5.
//  Copyright © 2015年 Neva. All rights reserved.
//

import JSONModel
import SSObject
//import Mantle

class BaseInfo: SSObject {
//    override func dateFormatWithPropertyName(propertyName: String) -> String {
//        return "yyyy-MM-dd HH:mm:ss"
//    }
}


class LoginInfo: BaseInfo {
    
    /// 登陆信息
    var info: UserInfo?
    
    /// 状态: 1为正常， 0为异常
    var status: NSNumber?
    
    /// 错误码
    var errorcode: NSNumber?
    
    /// 所有支持的服务器组
    var servergroup: [ServerInfo]?
    
    override func arrayClassWithPropertyName(propertyName: String) -> AnyClass {
        return ServerInfo.self
    }
}

/// 用户信息
class UserInfo: BaseInfo {
    
    var username: String?
    var password: String?
    
    /// 唯一标识符
    var uid: String?
    
    /// 套餐名字(中文)
    var srvname: String?
    
    /// 套餐名字(英文)
    var englishsrvname: String?
    
    var limitexpiration: NSNumber?
    
    /// 服务器ID
    var srvid: NSNumber?
    
    /// [未知字段]
    var enableuser: NSNumber?
    
    /// 套餐开始时间
    var startime: NSDate?
    
    /// 套餐过期时间
    var expiration: NSDate?
    
    var enablenas: NSNumber?
    
    /// 服务状态码
    var servstatus: NSNumber?
}

/// 服务器信息
class ServerInfo: BaseInfo {
    
    /// 是否VIP
    var vip: NSNumber?
    
    /// 分组ID
    var groupid: String?
    
    /// 分组名字
    var groupname: String?
    
    /// 图标(URL)
    var image: String?
    
    /// 分组名字(英文)
    var englishname: String?
    
    /// 分组下的主机信息
    var nas: [HostInfo]?
    
    override func arrayClassWithPropertyName(propertyName: String) -> AnyClass {
        return HostInfo.self
    }
}

class HostInfo: BaseInfo {
    
    /// 主机名(域名或IP)
    var nasname: String?
    
    /// 短名字(用于显示)
    var shortname: String?
    
    /// 主机ID
    var id: String?
    
    /// 在线用户数
    var onlineuser: NSNumber?
}
