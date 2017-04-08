//
//  InterceptorChain.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 28/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import RxSwift

/// Class which handles the chaining of the input interceptors given
/// - `Input` generic forward to the same generic of the `AnyInterceptor`.
/// - It's the entry point of the SwiftRxInterceptor library when you want to use it.
public final class InterceptorChain<Input> {
    private var interceptors: [AnyInterceptor<Input>]
    
    // MARK: Initializer

    /// Convenience initializer
    public convenience init() {
        self.init(interceptors: [AnyInterceptor<Input>](), input: nil)
    }

    /// Convenience initializer taking the input to intercept
    public convenience init(input: Input) {
        self.init(interceptors: [AnyInterceptor<Input>](), input: input)
    }
    
    /// Initialize with an array of interceptors which will intercept the input given
    public init(interceptors: [AnyInterceptor<Input>], input: Input?) {
        self.interceptors = interceptors
        self.input = input
    }
    
    // MARK: Public
    
    /// The input which is intercept when `InterceptorChain` proceed
    public var input: Input?
    
    /// Add an interceptor
    /// - note: It returns `Self` to chain initialization
    /// - warning: the AnyInterceptor in parameter must have the same `Input` type of the `InterceptorChain`
    /// - returns: `InterceptorChain`
    public func add(interceptor: AnyInterceptor<Input>) -> InterceptorChain {
        interceptors.append(interceptor)
        
        return self
    }

    /// Launch the chaining of the input:
    /// - given in parameter
    /// - if not, take the class property (set at the initialization or publicly set)
    /// - if not, raise a fatalError
    /// - parameter object: the `Input` object to proceed.
    /// - warning: You must set the input object at the initialization of the `InterceptorChain<Input>` or set the class property or
    /// give it in parameter of this method.
    /// - returns: `Observable` of `Input`
    public func proceed(object: Input? = nil) -> Observable<Input> {
        if let object = object {
            return proceedNext(with: object)
        } else if let input = self.input {
            return proceedNext(with: input)
        } else {
            fatalError("You must set an input object to the chain (setter or in parameter of `proceed` method)")
        }
    }

    // MARK: Private

    private func proceedNext(with input: Input) -> Observable<Input> {
        guard let interceptor = self.interceptors.first else {
            return Observable.just(input)
        }

        var interceptors = self.interceptors
        interceptors.removeFirst()

        return interceptor.intercept(chain: InterceptorChain(interceptors: interceptors, input: input))
    }
}
