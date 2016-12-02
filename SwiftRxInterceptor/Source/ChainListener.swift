//
//  ChainListener.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 26/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import RxSwift

/// Be able to be notified when the `Input` object has finished to be chain.
/// - note: It's here where the `Output` object is created.
public protocol ChainListener {
    associatedtype Input
    associatedtype Output
    
    /// Method called when `Input` object chaining is done
    /// - parameter input: `Input` object which has been intercept by interceptors
    /// - returns: Observable of `Output`
    /// - note: It's here where the `Output` object is created. The `Output` object chaining will start when
    /// the `Observable` will start to emit.
    func proceedDidFinished(with input: Input) -> Observable<Output>
}
