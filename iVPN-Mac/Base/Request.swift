//
//  Request.swift
//  iVPN-Mac
//
//  Created by Steven on 15/11/5.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Alamofire
import SwiftyJSON
import SSObject

// 天行VPN的API
struct APIStore {
    
    struct API {
        
        let URL: String
        
        let method: Alamofire.Method
        
        let parameters: [String: AnyObject]?
        
        init(URL url: String, method: Alamofire.Method, parameters: [String: AnyObject]? = nil) {
            self.URL = url
            self.method = method
            self.parameters = parameters
        }
    }
    
    /********** 获取版本更新信息(GET)
    http://60.173.12.48/xksyvpn/ios/vesion_vpn_ini.php
    {
    "v": 1.04,
    "log": ["v1.04正式版发布", "1.连接国家服务器组优化", "2.修复部分用户不能登录的问题"]
    }
    **********/
    static let updateVersion = API(
        URL: "http://60.173.12.48/xksyvpn/ios/vesion_vpn_ini.php",
        method: .GET)
    
    /********** 获取登录服务器列表(POST)
    http://114.80.116.142:81/serviceAddress/geturl.php
    返回参数:
    docurl: 服务器
    docurlbk: 备份服务器
    disblexinjiang: [未知参数]
    ischeck: [未知参数]
    返回数据样本:
    {
    "docurl": "http://106.185.48.189/loginserver/",
    "docurlbk": "http://114.80.116.142:81/loginserver/",
    "disblexinjiang": "0",
    "ischeck" = "1.06"
    }
    **********/
    static let serverList = API(
        URL: "http://114.80.116.142:81/serviceAddress/geturl.php",
        method: .POST)
    
    /********** 注册账号(POST)
    http://106.185.48.189/loginserver/interFace/vpninterFace/register.php
    请求参数:
    Equipment:  iPhone7,2
    keychain:   AF9E5382-39B7-42E1-BF37-CA2A51526433
    plat:       1
    system:     9.0.2
    返回参数与登陆服务器接口相同
    **********/
    static let register = API(
        URL: "interFace/vpninterFace/register.php",
        method: .POST,
        parameters: ["Equipment": $.platform, "keychain": $.UUID, "plat": 1, "system": $.system])
    
    
    /********** 登陆获取服务器列表(POST)
    参数:
    keychain:   AF9E5382-39B7-42E1-BF37-CA2A51526433
    plat:       1
    http://106.185.48.189/loginserver/interFace/vpninterFace/login.php
    返回参数说明:
    info: 登陆信息
    "username": "AF9E5382-39B7-42E1-BF37-CA2A51526433",
    "password": "888888",
    "uid": "AF9E5382-39B7-42E1-BF37-CA2A51526433",
    "srvname": "免费体验套餐",
    "englishsrvname": "Free Trial Plan",
    "limitexpiration": 0,
    "srvid": 44,
    "enableuser": "1",
    "startime": "2015-07-08 15:54:30",
    "expiration": "0000-00-00 00:00:00",
    "enablenas": "0",
    "servstatus": -1
    servergroup: 服务器列表数组
    "vip": "0",
    "groupid": "3",
    "groupname": "免费-美国，弗里莱特",
    "image": "http://114.80.116.142:81/interFace/servimage/serve_meiguo.png",
    "englishname": "Free-Fremont, USA",
    "nas": 服务器配置信息
    "nasname": "74.207.246.72",
    "shortname": "ipsec*USA09",
    "id": "33",
    "onlineuser": "17"
    **********/
    static let login = API(
        URL: "interFace/vpninterFace/login.php",
        method: .POST,
        parameters: ["keychain": $.UUID, "plat": 1])
    
    
    /********** 获取消息通知(GET)
    http://114.80.116.142:81/interFace/iosvpnnotice.php?channel=1
    {
    "v": "1015",
    "con": "尊敬的天行用户：机房故障已修复！请您关闭软件，重新尝试连接，给您带来的不便，敬请谅解。",
    "enddatetime": "2015-9-11 15:30:00"
    }
    **********/
    static let notice = API(
        URL: "http://114.80.116.142:81/interFace/iosvpnnotice.php?channel=1",
        method: .GET)
}

public extension Alamofire.Request {
    
    func responseJSONObject(handler: Response<JSON, NSError> -> Void) -> Self {
        
        return response(responseSerializer: ResponseSerializer(serializeResponse: { (request, response, data, error) -> Result<JSON, NSError> in
            
            guard error == nil else { return .Failure(error!) }
            
            if let d = data {
                let json = JSON(data: d)
                print("URL:\(request!.URL!)", json)
                return .Success(json)
            } else {
                return .Success(nil)
            }
            
        }), completionHandler: handler)
    }
    
    public func responseObjects<T: SSObject> (type: T.Type, completion: (NSURLRequest, NSURLResponse?, [T]?, NSError?)->()) -> Self {
        
        return response(responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments), completionHandler: { (response) -> Void in
            if let error = response.result.error {
                completion(response.request!, response.response, nil, error)
            } else {
                let objects = T.arrayWithDictionarys(response.result.value as? [AnyObject]) as? [T]
                print("URL:\(response.request!.URL)", response.result.value)
                completion(response.request!, response.response, objects, nil)
            }
        })
    }
    
    public func responseObject<T: SSObject> (type: T.Type, completion: (NSURLRequest, NSURLResponse?, T?, NSError?)->()) -> Self {
        
        return response(responseSerializer: Request.JSONResponseSerializer(options: .AllowFragments), completionHandler: { (response) -> Void in
            if let error = response.result.error {
                completion(response.request!, response.response, nil, error)
            } else {
                let object = T(dictionary: response.result.value as? [NSObject: AnyObject])
                print("URL:\(response.request!.URL)", response.result.value)
                completion(response.request!, response.response, object, nil)
            }
        })
    }
}

extension $ {
    
    // 掉用API
    class func request(api: APIStore.API, handler: (request: Alamofire.Request) -> Void ) {
        
        // 用是否包含http前缀判断是否为绝对路径
        let hasHTTPPrefix = api.URL.lowercaseString.hasPrefix("http")
        
        if !hasHTTPPrefix && loginServerIP == nil {
            
            // 获取服务器IP
            request(APIStore.serverList, handler: { (request) -> Void in
                request.responseJSONObject({ (response) -> Void in
                    
                    if let json = response.result.value {
                        
//                        $.loginServerIP = json["docurl"].string
                        $.loginServerIP = json["docurl"].string
                        
                        $.request(api, handler: handler)
                    }
                    
                })
            })
            
        } else {
            
            // 调用API
            var URL: String
            
            if hasHTTPPrefix {
                URL = api.URL
            } else {
                URL = loginServerIP!.stringByAppendingString(api.URL)
            }
            
            handler( request: Alamofire.request(api.method, URL, parameters: api.parameters) )
            
        }
    }
    
    
    // 登录
    class func login( handler: (info: LoginInfo?) -> Void ) {
        
        $.request(APIStore.login) { (request) -> Void in
            
            request.responseObject(LoginInfo.self) { (_, _, info, _) -> () in
                
                if info?.errorcode?.integerValue > 0 {
                    
                    // 掉用注册接口
                    $.request(APIStore.register, handler: { (request) -> Void in
                        request.responseObject(LoginInfo.self) { (_, _, info, _) -> () in
                            handler(info: info)
                        }
                    })
                    
                } else {
                    // 登录成功，该干嘛干嘛
                    handler( info: info )
                }
            }
        }
    }

}