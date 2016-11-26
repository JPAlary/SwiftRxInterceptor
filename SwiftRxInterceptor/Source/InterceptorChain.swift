//
//  InterceptorChain.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 28/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import RxSwift

/// Class which handles the chaining of the interceptors given
/// - `Input` and `Output` generics forward to the same generics of the `AnyChainListener` and the `AnyInterceptor`.
/// - It's the entry point of the SwiftInterceptor library when you want to use it.
public class InterceptorChain<Input, Output> {
    private var interceptors: [AnyInterceptor<Input, Output>]
    private let listener: AnyChainListener<Input, Output>
    
    // MARK: Initializer
    
    /// Convenience initializer taking the chain listener and the input to intercept
    public convenience init(listener: AnyChainListener<Input, Output>, input: Input) {
        self.init(interceptors: [AnyInterceptor<Input, Output>](), listener: listener, input: input)
    }
    
    /// Initialize with an array of interceptors which will intercept the input given and notified the listener given
    public init(interceptors: [AnyInterceptor<Input, Output>], listener: AnyChainListener<Input, Output>, input: Input) {
        self.interceptors = interceptors
        self.listener = listener
        self.input = input
    }
    
    // MARK: Public
    
    /// The input which is intercept when `InterceptorChain` proceed
    public var input: Input
    
    /// Add an interceptor
    /// - note: It returns `Self` to have fluid API (chain initialization and adding interceptor)
    /// - warning: the AnyInterceptor in parameter must have the same `Input` and `Output` type of the `InterceptorChain`
    /// - returns: `InterceptorChain`
    public func add(interceptor: AnyInterceptor<Input, Output>) -> InterceptorChain {
        interceptors.append(interceptor)
        
        return self
    }
    
    /// Launch the chaining of the input given at the initialization and when the listener responds, the chaining of the `Output`.
    /// - returns: Observable of `Output`
    public func proceed() -> Observable<Output> {
        guard let interceptor = self.interceptors.first else {
            return listener.proceedDidFinished(with: input)
        }
        
        var interceptors = self.interceptors
        interceptors.removeFirst()
        
        return interceptor.intercept(chain: InterceptorChain(interceptors: interceptors , listener: listener, input: input))
    }
}
