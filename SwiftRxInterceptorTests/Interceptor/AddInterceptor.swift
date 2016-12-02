//
//  AddInterceptor.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 28/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

@testable import SwiftRxInterceptor
import RxSwift

struct AddInterceptor: Interceptor {
    private let modifyEndValue: Bool
    
    // MARK: Initializer
    
    init(modifyEndValue: Bool) {
        self.modifyEndValue = modifyEndValue
    }
    
    // MARK: Interceptor
    
    func intercept(chain: InterceptorChain<Int, Int>) -> Observable<Int> {
        var value = chain.input
        value += 1
        
        chain.input = value
        
        return chain
            .proceed()
            .map({ (value) -> Int in
                if self.modifyEndValue {
                    return value + 1
                } else {
                    return value
                }
            })
    }
}

