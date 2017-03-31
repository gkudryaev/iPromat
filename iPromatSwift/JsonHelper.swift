//
//  JsonHelper.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 04.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import Foundation
import UIKit


enum JsonUrls {
    /* 
        Пример использования тубов и функций в enum
        Один url может вызываться разными методами post - добавить, put - обновить, delete - удалить
        горе - что нельзя делать enum тубами - приходится так извращаться
        Блин - через это хрень можно еще и параметры со всей хренью передавать
        то есть они и будут вызов запроса - нужно попробовать - может фигня получиться. Нет понял - не получается. Это для хранения переменных
     Нет - все-равно нужно пробовать - может красиво получиться. попробовал - не понравилось
     */
    case catalog // - пробовал ((_ json: [String: Any]?, _ errStr: String?) -> Void )
    case login
    case checkPhone
    case checkPhoneCode
    case newCustomer
    case test
    case profile
    case profileUpdate
    case order
    case orderList
    case orderCancel
    
    func request () -> (url: String, method: String) {
        //let host = "http://192.168.0.135:8080/ords/test/"
        let host = "https://apex.oracle.com/pls/apex/grigh/"
        switch self {
        case .catalog: //пробовал (complete):
            return (host + "v0.2/items", "GET")
        case .login:
            return (host + "v0.2/login", "POST")
        case .checkPhone:
            return (host + "v0.2/check_phone", "POST")
        case .checkPhoneCode:
            return (host + "v0.2/check_phone_code", "POST")
        case .newCustomer:
            return (host + "v0.2/customers", "POST")
        case .test:
            return (host + "v0.2/test", "POST")
        case .profile:
            return (host + "v0.2/profile", "POST")
        case .profileUpdate:
            return (host + "v0.2/profileUpdate", "POST")
        case .order:
            return (host + "v0.2/order", "POST")
        case .orderList:
            return (host + "v0.2/order_list", "POST")
        case .orderCancel:
            return (host + "v0.2/order_cancel", "POST")
            
        }
    }
    
    
    
}

class JsonHelper {
    
    class func request (_ url: JsonUrls,
                        _ params: Dictionary<String, Any>?,
                        _ viewController: UIViewController?,
                        _ completion:@escaping (_ json: [String: Any]?, _ errStr: String?) -> Void
        ) {
        // может быть это лишний слой - все засунуть в этот вызов
        let r = url.request()
        loadDataFromURL (
            r.url,
            method: r.method,
            params:params,
            viewController:viewController){
                (json: [String: Any]?, error: String?) -> Void in
                if let respError = error {
                    print ("error" + respError)
                }
                completion (json, error)
        }
    }
    
    
    class func loadDataFromURL(_ urlString: String,
                               method: String,
                               params: Dictionary<String,Any>?,
                               viewController: UIViewController?,
                               completion:@escaping (_ json: [String:Any]?, _ errStr: String?) -> Void) {
        
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration:configuration)
        
        let url = URL(string:urlString)
        let request = NSMutableURLRequest(url: url!)
        
        request.httpMethod = method
        
        if let params = params {
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
        }
        
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let loadDataTask = session.dataTask(with: request as URLRequest) {
            (data: Data?, response: URLResponse?, error: Error?) -> Void in
            
            DispatchQueue.main.async {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        completion(nil, "HTTP status code /(httpResponse.statusCode)")
                    } else {
                        if let json = try? JSONSerialization.jsonObject(with: data!)  as? [String: Any] {
                            if let vc = viewController, let txtError = json?["error"] as? String
                            {
                                //AppModule.sharedInstance.alertError(txtError, view: vc)
                                completion(nil, txtError)
                            } else {
                                completion(json, nil)
                            }
                        }
                    }
                }
            }
        }
        
        loadDataTask.resume()
    }
}
