//
//  LocaleInterceptor.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 30/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import Foundation
import RxSwift

struct AddLocaleInterceptor: Interceptor {
    enum Key {
        static let locale = "locale"
    }
    
    // MARK: Interceptor
    
    func intercept(chain: InterceptorChain<URLRequest>) -> Observable<URLRequest> {
        guard let request = chain.input else {
            return chain.proceed()
        }

        var mutableRequest = request
        
        guard let url = mutableRequest.url?.absoluteString else {
            return chain.proceed()
        }
        
        let separator = url.contains("?") ? "&" : "?"
        
        guard let finalURL = URL(string: url + separator + Key.locale + "=" + "fr_FR") else {
            return chain.proceed()
        }
        
        mutableRequest.url = finalURL
        
        return chain.proceed(object: mutableRequest)
    }
}
