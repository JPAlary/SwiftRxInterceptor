//
//  InterceptorChainTests.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 28/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

@testable import SwiftRxInterceptor
import XCTest
import RxSwift

final class InterceptorChainTests: XCTestCase {
    private let disposeBag = DisposeBag()
    
    func test_GivenIntValue_ThenChaining_ShouldSucceed() -> Void {
        let expectation = self.expectation(description: "Wait for chaining")
        
        let chain = InterceptorChain(input: 1)
            .add(interceptor: AnyInterceptor(base: AddInterceptor()))
            .add(interceptor: AnyInterceptor(base: AddInterceptor()))
            .add(interceptor: AnyInterceptor(base: MinusInterceptor()))
        
        chain
            .proceed()
            .subscribe { (event) in
                if case .next(let value) = event {
                    expectation.fulfill()
                    XCTAssertTrue(value == 2)
                }
            }
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 3.0)
    }
}

private struct AddInterceptor: Interceptor {

    // MARK: Interceptor

    func intercept(chain: InterceptorChain<Int>) -> Observable<Int> {
        guard let input = chain.input else {
            return chain.proceed()
        }

        return chain.proceed(object: input + 1)
    }
}

private struct MinusInterceptor: Interceptor {

    // MARK: Interceptor

    func intercept(chain: InterceptorChain<Int>) -> Observable<Int> {
        guard let input = chain.input else {
            return chain.proceed()
        }

        return chain.proceed(object: input - 1)
    }
}
