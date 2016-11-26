//
//  HTTPClient.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 30/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import Foundation
import RxSwift

enum HTTPClientResult {
    case success(Response)
    case error(Error)
    case networkError(Error)
}

protocol HTTPClient {
    func send(request: URLRequest) -> Observable<HTTPClientResult>
}

class MyHTTPClient: HTTPClient {
    private let requestor: FakeRequestor
    
    // MARK: Initializer
    
    init(requestor: FakeRequestor) {
        self.requestor = requestor
    }
    
    // MARK: HTTPClient
    
    func send(request: URLRequest) -> Observable<HTTPClientResult> {
        return InterceptorChain(listener: AnyChainListener(base: requestor), input: request)
            .add(interceptor: AnyInterceptor(base: CredentialsInterceptor()))
            .add(interceptor: AnyInterceptor(base: AddLocaleInterceptor()))
            .proceed()
            .map { .success($0) }
    }
}
