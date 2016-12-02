//
//  Interceptor.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 26/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import RxSwift

/// Be able to intercept an object of type `Input` and `Output`
public protocol Interceptor {
    associatedtype Input
    associatedtype Output
    
    /// Intercept with an Interceptorchain and respond with an Observable
    /// - parameter chain: instance of `InterceptorChain` containing
    /// the input object. The output object can be also intercept through the `proceed` method, asynchronously.
    /// - returns: Observable of Output
    func intercept(chain: InterceptorChain<Input, Output>) -> Observable<Output>
}
