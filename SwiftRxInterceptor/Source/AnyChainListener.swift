//
//  AnyChainListener.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 28/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import RxSwift

/// Struct that conforms to `ChainListener`
/// - Type erasure of `ChainListener` protocol to be able to make homogeneous arrays or for dependency injection.
/// - The `Input` and `Output` generics types forward the two generics types in `ChainListener` protocol
public struct AnyChainListener<Input, Output>: ChainListener {
    private let _callback: (Input) -> Observable<Output>
    
    public init<C: ChainListener>(base: C) where C.Input == Input, C.Output == Output {
        _callback = base.proceedDidFinished
    }
    
    public func proceedDidFinished(with input: Input) -> Observable<Output> {
        return _callback(input)
    }
}

