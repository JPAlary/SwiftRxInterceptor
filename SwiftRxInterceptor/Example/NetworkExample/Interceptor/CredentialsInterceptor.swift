//
//  CredentialsInterceptor.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 30/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import Foundation
import RxSwift

struct CredentialsInterceptor: Interceptor {
    
    enum Key {
        static let accessToken = "access_token"
    }
    
    // MARK: Interceptor
    
    func intercept(chain: InterceptorChain<URLRequest>) -> Observable<URLRequest> {
        
        /* Note:
         The token value can be retrieve from storage or from an api call.
         As the chaining is asynchronous, you can check in this interceptor if you need to:
         - GET a token
         - refresh it
         wait for a response and `proceed` the chaining.
         
         In this example, I just add a simple string value but don't hesitate to handle your
         different credentials with an interceptor !
         */

        guard let request = chain.input else {
            return chain.proceed()
        }
        
        var mutableRequest = request

        guard let url = mutableRequest.url?.absoluteString else {
            return chain.proceed()
        }
        
        let separator = url.contains("?") ? "&" : "?"
        
        guard let finalURL = URL(string: url + separator + Key.accessToken + "=" + "some_value") else {
            return chain.proceed()
        }
        
        mutableRequest.url = finalURL
        
        return chain.proceed(object: mutableRequest)
    }
}
