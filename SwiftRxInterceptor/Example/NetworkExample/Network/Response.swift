//
//  Response.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 30/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import Foundation

/*
 This class is used as an example, but you should have Data, Error, statusCode, etc in it ;)
 I just store the final request url to print it at the end and show the work of the interceptors
 */
struct Response {
    let request: URLRequest
    
    // MARK: Initializer
    
    init(request: URLRequest) {
        self.request = request
    }
}
