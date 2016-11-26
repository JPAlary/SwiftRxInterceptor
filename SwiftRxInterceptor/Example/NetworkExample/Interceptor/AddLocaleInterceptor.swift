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
    
    func intercept(chain: InterceptorChain<URLRequest, Response>) -> Observable<Response> {
        var request = chain.input
        
        guard let url = request.url?.absoluteString else {
            return chain.proceed()
        }
        
        let separator = url.contains("?") ? "&" : "?"
        
        guard let finalURL = URL(string: url + separator + Key.locale + "=" + "fr_FR") else {
            return chain.proceed()
        }
        
        request.url = finalURL
        chain.input = request
        
        return chain.proceed()
    }
}
