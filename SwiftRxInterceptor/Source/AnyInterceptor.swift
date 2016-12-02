//
//  AnyInterceptor.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 26/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import RxSwift

/// Struct that conforms to `Interceptor` protocol
/// - Type erasure of `Interceptor` protocol to be able to make homogeneous arrays or dependency injection.
/// - The `Input` and `Output` generics types forward to the two generics types in `Interceptor` protocol
public struct AnyInterceptor<Input, Output>: Interceptor {
    private let _intercept: (InterceptorChain<Input, Output>) -> Observable<Output>
    
    // MARK: Initializer
    
    init<I: Interceptor>(base: I) where I.Input == Input, I.Output == Output {
        _intercept = base.intercept
    }
    
    // MARK: Interceptor
    
    public func intercept(chain: InterceptorChain<Input, Output>) -> Observable<Output> {
        return _intercept(chain)
    }
}
