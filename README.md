# SwiftRxInterceptor

This implementation of `Interceptor` in Swift is the same as the [SwiftInterceptor][3] one. It just used [RxSwift][4] instead of closure for the asynchronous part.

## Introduction

This Interceptor "concept" comes from the Interceptor implementation in the library Okhttp for Android (see [Okhttp interceptor wiki][1]).
This mechanism is very powerful when you want to modify/do some actions on an input object before and after the process it was given for.
See the interceptors as a middleware between the source of your input object and its final destination.

In this Swift implementation, two more things has been added:
- Generic input and ouput: in the Okhttp implementation, the interceptor intercepts a **Request** and returns a **Response**.
- Asynchronous process: the interceptor returns an Observable of `Ouput` object.

With Interceptors, you have:
- clean and robust solution to handle:
	- network monitoring
	- adding parameters for all your requests in a same place
	- authentication (get/refresh a token), signed your request before sending it
	- retry failed request
	- and more.. ;)
- clear distribution of roles:
	- each interceptor has a clear purpose
	- do only one thing on the input and output object
- an easy way to improve test coverage with unit tests on each of your interceptors

To finish, as it's generic, you can apply this mechanism in another context. Be creative ! :)

## Installation

### Cocoapods

[Cocoapods][2] is a dependency manager for Cocoa projects. You can install it with the command:
```bash
$ gem install cocoapods
```

To add SwiftRxInterceptor to your project, write in your `Podfile` the following lines:
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'SwiftRxInterceptor'
end
```

Then run in a terminal the command:
```bash
$ pod install
```

## Usage

### Interceptor
First thing to do, it's to create the Interceptor(s) you need. Remember, Interceptor is designed to be used to intercept the input object and/or the output object.
**Group your Interceptors by concern and avoid duplicated ones**

To do so, you just have to conform to the protocol Interceptor:

```swift
protocol Interceptor {
    associatedtype Input
	associatedtype Output
	
	func intercept(chain: InterceptorChain<Input, Output>) -> Observable<Output>
}
```
#### Example

**Intercept the input**

```swift
struct MyInterceptor: Interceptor {
	func intercept(chain: InterceptorChain<URLRequest, Data>) -> Observable<Data> {
		// 1) Retrieve the input object (the request)
		var request = chain.input

		// 2) Do things with/on the request

		// 3) Give it back to the chain
		chain.input = request

		// 4) Continue the chaining to others interceptors.
		return chain.proceed()
	}
}
```

**Intercept the input and the output**

```swift
struct MyInterceptor: Interceptor {
	func intercept(chain: InterceptorChain<URLRequest, Data>) -> Observable<Data> {
		// 1) Retrieve the input object (the request)
		var request = chain.input

		// 2) Do things with/on the request
		
		// 3) Give it back to the chain
		chain.input = request

		// 4) Continue the chaining to others interceptors and intercept the output
		return chain
			.proceed()
			.do(onNext: { (data) in
				// 5) Do things with/on the data object
			})

		// Note: Use the RX operator you need (map, flatMap, whatever). Obviously, the only condition is to return the same type as the `Output` generic type. Here, it's a Data
	}
}
```

### Chain listener

As this Swift implementation is generic, so, not tighly coupled to a network purpose, it needs a component to do the final job.

```swift
protocol ChainListener {
	associatedtype Input
	associatedtype Output

	func proceedDidFinished(with input: Input) -> Observable<Output>
}
```

When the interceptor's chaining has finish to intercept the input object, the Interceptor chain will call the method `proceedDidFinished`.
It's here where you do the initial job. In a network context, it's where you send the request (input). When you get the response, you do what you need to do, but you must return an Observable of `Output` type. Then the interception of the output (your response) will begin. 

#### Example

```swift
struct MyChainListener: ChainListener {
	func proceedDidFinished(with input: URLRequest) -> Observable<Data> {
		// 1) I use the URLSession+Rx methods like `.data(URLRequest)` or you can create your Observable to do some extra stuff
	
		return URLSession.shared.rx.data(request: input)
	}
}
```

### Interceptor chain
--------

When you have your interceptors and the chain listener implemented, it's finished ! 

To launch the process:

```swift
let disposeBag = DisposeBag()

// 1) I create an instance of interceptor chain. You can add many interceptor you want.
let chain = InterceptorChain(listener: AnyChainListener(base: MyChainListener()), input: request)
	.add(interceptor: AnyInterceptor(base: MyInterceptor()))

// 2) Launch the process
chain
	.proceed()
	.subscribe { (event) in
		// 3) You get your data in the `.next` case	
	}
	.addDisposableTo(disposeBag)
}
```

## Additional informations

For more explanations about the interceptor mechanism, don't hesitate to read the documentation in the [okhttp wiki][1].
For non-RxSwift fans, you can have a look at the [SwiftInterceptor][3] implementation without any dependencies.

[1]: https://github.com/square/okhttp/wiki/Interceptors
[2]: https://cocoapods.org/
[3]: https://github.com/JPAlary/SwiftInterceptor
[4]: https://github.com/ReactiveX/RxSwift
