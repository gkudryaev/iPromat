//
//  UIImageView.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 09.09.16.
//  Copyright © 2016 Kudryaev, Grigoriy. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromUrl(_ urlString: String?) {
        
        if urlString == nil {
            return
        }
        
        let urlStr = urlString?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: urlStr!)
        let session = URLSession.shared
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "GET"
        
        let loadDataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            DispatchQueue.main.async {
                /*
                 if let responseError = error {
                    print(responseError.userInfo["error"]?["type"] as? String)
                } else 
                */
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        print("HTTP status code /(httpResponse.statusCode)")
                    } else {
                        self.image = UIImage(data: data!)
                    }
                }
            }
        })
        loadDataTask.resume()
    }
    
}
