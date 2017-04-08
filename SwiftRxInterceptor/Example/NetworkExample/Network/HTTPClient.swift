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

final class MyHTTPClient: HTTPClient {
    private let requestChain: InterceptorChain<URLRequest>
    private let responseChain: InterceptorChain<Response>
    
    // MARK: Initializer

    convenience init() {
        self.init(
            requestChain: InterceptorChain<URLRequest>()
                .add(interceptor: AnyInterceptor(base: CredentialsInterceptor()))
                .add(interceptor: AnyInterceptor(base: AddLocaleInterceptor())),
            responseChain: InterceptorChain<Response>()
        )
    }
    
    init(requestChain: InterceptorChain<URLRequest>, responseChain: InterceptorChain<Response>) {
        self.requestChain = requestChain
        self.responseChain = responseChain
    }
    
    // MARK: HTTPClient
    
    func send(request: URLRequest) -> Observable<HTTPClientResult> {
        return requestChain
            .proceed(object: request)
            .map { (request) -> Response in
                // Here you should sent the request...
                return Response(request: request)
            }
            .withLatestFrom(Observable.just(responseChain)) { $0 }
            .flatMap { $1.proceed(object: $0) }
            .map { .success($0) }
    }
}
