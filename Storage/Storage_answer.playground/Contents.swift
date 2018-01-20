//: Playground - noun: a place where people can play

import UIKit
import XCTest

var str = "Hello, playground"

// Network service
// + Support plugins. For instance, Logger, Credential and NetworkActivity
// + Support Caching

protocol Fetcherable {
    func response(_ request: URLRequest, complete: @escaping (Data) -> Void)
}

class AlamofireFetcher: Fetcherable {
    func response(_ request: URLRequest, complete: @escaping (Data) -> Void) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            
            // Get data
            let fakeData = "data"
            complete(fakeData.data(using: String.Encoding.utf8)!)
        }
    }
}

protocol Plugin {
    func process(_ request: URLRequest) -> URLRequest
}

struct LoggerPlugin: Plugin {
    
    func process(_ request: URLRequest) -> URLRequest {
        
        // Process
        print(request.url!.absoluteString)
        
        // Return
        return request
    }
}

struct CredentialPlugin: Plugin {
    
    func process(_ request: URLRequest) -> URLRequest {
        
        // Process
        
        // Return
        return request
    }
}

struct NetworkActivityPlugin: Plugin {
    
    func process(_ request: URLRequest) -> URLRequest {
        
        // Process
        
        // Return
        return request
    }
}

protocol Cachable {
    associatedtype Key: Hashable
    associatedtype Element
    
    func item(at key: Key) -> Element?
    func setItem(_ item: Element, with key: Key)
}

final class SafeCache<Key: Hashable, Element>: Cachable {
    
    // Private cache
    private var cache: [Key: Element] = [:]
    
    // Lock
    // Avoid race-condition
    private let lock = NSLock()
    
    //
    func item(at key: Key) -> Element? {
        
        // Duplicated code
        // Should use Serial Queue instead
        lock.lock()
        defer {
            lock.unlock()
        }
        return cache[key]
    }
    
    func setItem(_ item: Element, with key: Key) {
        
        // Duplicated code
        // Should use Serial Queue instead
        lock.lock()
        defer {
            lock.unlock()
        }
        cache[key] = item
    }
}

protocol NetworkServiceType {
    func request(endpoint: String, complete: @escaping (Data) -> Void)
}

final class NetworkService: NetworkServiceType {
    
    // Plugins
    // Respect Open-Closed
    private let plugins: [Plugin]
    
    // Fetcher
    // Respect D in SOLID
    private let fetcher: Fetcherable
    
    // Cache
    
    // It's not good when depending on concrete class SafeCache here
    // private let cache: AnyCache<String, Data> is potential candidar
    // AnyCache is Type Erasure, wrapping the Cachable protocol
    // The reason is that the Swift doesn't allow to define Cachable<String, Data>
    // https://medium.com/@NilStack/swift-world-type-erasure-5b720bc0318a
    private let cache = SafeCache<String, Data>()
    
    // Init
    init(fetcher: Fetcherable, plugins: [Plugin] = []) {
        self.fetcher = fetcher
        self.plugins = plugins
    }
    
    class func `default`() -> NetworkService {
        let plugins: [Plugin] = [LoggerPlugin(),
                                 CredentialPlugin(),
                                 NetworkActivityPlugin()]
        let fetcher = AlamofireFetcher()
        return NetworkService(fetcher: fetcher, plugins: plugins)
    }
    
    func request(endpoint: String, complete: @escaping (Data) -> Void) {

        // Get in cache
        if let data = cache.item(at: endpoint) {
            complete(data)
            return
        }
        
        // Create request
        var request = URLRequest(url: URL(string: endpoint)!)
        
        // Plugins
        request = processPlugins(request: request)
        
        // Exectue
        fetcher.response(request) {[unowned self] (data) in
            
            // Cache
            self.cache.setItem(data, with: endpoint)
            
            // Call complete
            DispatchQueue.main.async {
                complete(data)
            }
        }
    }
    
    private func processPlugins(request: URLRequest) -> URLRequest {
        return plugins.reduce(into: request, { (newRequest, plugin) in
            newRequest = plugin.process(newRequest)
        })
    }
}

let service = NetworkService.default()
service.request(endpoint: "http://nghiatran.me/home") { (data) in
    
    // binding UI
}

// Test
class SpyPlugin: Plugin {
    var isCalled = false
    func process(_ request: URLRequest) -> URLRequest {
        isCalled = true
        return request
    }
}

struct StubFetcher: Fetcherable {
    
    let output: String
    
    func response(_ request: URLRequest, complete: @escaping (Data) -> Void) {
        complete(output.data(using: String.Encoding.utf8)!)
    }
}

let urlTest = "http://www.google.com"
func testAllPluginsIsCalled() {
    
    let expected = [true, true, true]
    let plugins = [SpyPlugin(),
                   SpyPlugin(),
                   SpyPlugin()]
    let fetcher = StubFetcher(output: "Hello")
    
    let service = NetworkService(fetcher: fetcher, plugins: plugins)
    service.request(endpoint: urlTest) { (_) in}
    
    let output = plugins.map { $0.isCalled }
    XCTAssertEqual(expected, output, "Should call all plugins")
}
testAllPluginsIsCalled()

func testReturnCorrectData() {
    let input = "Hello"
    let plugins = [SpyPlugin(),
                   SpyPlugin(),
                   SpyPlugin()]
    let fetcher = StubFetcher(output: input)
    let expected = input.data(using: String.Encoding.utf8)!
    
    // Playgournd doesn't support XCTest : /
    let expectation = expectation(description: "Fetch")
    
    let service = NetworkService(fetcher: fetcher, plugins: plugins)
    service.request(endpoint: urlTest) { (data) in
        XCTAssertEqual(data, expected)
        expectation.fulfill()
    }
    
    waitForExpectations(timeout: 10.0) { error in}
}

func testCacheRaceCondition() {
    
}

func testLoggerPlguin() {
    
}

func testNetworkActivityPlugin() {
    
}
