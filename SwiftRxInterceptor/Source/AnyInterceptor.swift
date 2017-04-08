//
//  AnyInterceptor.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 26/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import RxSwift

/// Class that conforms to `Interceptor` protocol
/// - Type erasure of `Interceptor` protocol to be able to make homogeneous arrays or dependency injection.
/// - The `Input` generic type forward to the generic type in `Interceptor` protocol
public final class AnyInterceptor<Input>: Interceptor {
    private let _intercept: (InterceptorChain<Input>) -> Observable<Input>
    
    // MARK: Initializer
    
    public init<I: Interceptor>(base: I) where I.Input == Input {
        _intercept = base.intercept
    }
    
    // MARK: Interceptor
    
    public func intercept(chain: InterceptorChain<Input>) -> Observable<Input> {
        return _intercept(chain)
    }
}
