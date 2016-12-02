//
//  ViewController.swift
//  SwiftRxInterceptor
//
//  Created by Jean-Pierre Alary on 26/11/2016.
//  Copyright © 2016 Jean-Pierre Alary. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    // MARK: View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        self.sendRequest()
    }
    
    // MARK: Private
    
    private func sendRequest() -> Void {
        let requestor = FakeRequestor()
        let httpClient = MyHTTPClient(requestor: requestor)
        let request = URLRequest(url: URL(string: "https://some-api.com")!)
        
        httpClient.send(request: request)
            .subscribe { (event) in
                if case .next(let result) = event {
                    switch result {
                    case .success(let response):
                        // print : https://some-api.com?access_token=some_value&locale=fr_FR
                        
                        print(response.requestUrl)
                    case .error(_):
                        // Handle error
                        break
                    case .networkError(_):
                        // Handle error
                        break
                    }
                }
            }
            .addDisposableTo(disposeBag)
    }
}
