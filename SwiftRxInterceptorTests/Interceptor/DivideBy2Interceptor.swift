//
//  DivideBy2Interceptor.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 28/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

@testable import SwiftRxInterceptor
import RxSwift

struct DivideBy2Interceptor: Interceptor {
    private let modifyEndValue: Bool
    
    // MARK: Initializer
    
    init(modifyEndValue: Bool) {
        self.modifyEndValue = modifyEndValue
    }
    
    // MARK: Interceptor
    
    func intercept(chain: InterceptorChain<Int, String>) -> Observable<String> {
        var value = chain.input
        value /= 2
        
        chain.input = value
        
        return chain
            .proceed()
            .map({ (value) -> String in
                if self.modifyEndValue {
                    return value + " divided"
                } else {
                    return value
                }
            })
    }
}
