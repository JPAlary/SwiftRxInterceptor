//
//  Interceptor.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 26/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import RxSwift

/// Be able to intercept an object of type `Input`
public protocol Interceptor {
    associatedtype Input
    
    /// Intercept with an InterceptorChain and respond with an Observable
    /// - parameter chain: instance of `InterceptorChain` containing
    /// the input object.
    /// - returns: Observable of `Input`
    func intercept(chain: InterceptorChain<Input>) -> Observable<Input>
}
