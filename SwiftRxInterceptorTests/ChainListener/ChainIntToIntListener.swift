//
//  ChainIntToIntListener.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 28/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

@testable import SwiftRxInterceptor
import RxSwift

struct ChainIntToIntListener: ChainListener {
    
    // MARK: ChainListener
    
    func proceedDidFinished(with input: Int) -> Observable<Int> {
        return Observable.just(input)
    }
}

