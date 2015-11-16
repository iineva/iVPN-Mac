//
//  NSImageView+AlamofireImage.swift
//  iVPN-Mac
//
//  Created by Steven on 15/11/7.
//  Copyright © 2015年 Neva. All rights reserved.
//

import Cocoa
import Alamofire
import AlamofireImage


extension NSImageView {
    
    /// 从网络加载图片
    func af_setImage(URL url: String, placeholderImage: NSImage?, errorImage: NSImage?) {
        
        // 取消之前的任务
        self.__af_currentRequest?.cancel()
        self.__af_currentRequest = nil
        
        // 设置默认图
        if let placeholderImage = placeholderImage {
            self.image = placeholderImage
        }
        
        // 加载图片
        let request = Alamofire.request(.GET, url)
        self.__af_currentRequest = request
        
        request.responseImage {
            [weak self] response in
            
            if let image = response.result.value {
                // 加载成功
                self?.image = image
            } else if let errorImage = errorImage {
                // 加载失败，设置失败图
                self?.image = errorImage
            }
        }
    }
    
    func af_setImage(URL url: String, placeholderImage: NSImage?) {
        self.af_setImage(URL: url, placeholderImage: placeholderImage, errorImage: nil)
    }
    
    func af_setImage(URL url: String) {
        self.af_setImage(URL: url, placeholderImage: nil, errorImage: nil)
    }

}