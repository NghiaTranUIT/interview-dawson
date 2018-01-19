//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


// Network service
// + Support plugins. For instance, Logger, Credential and NetworkActivity
// + Support Caching

class Alamofire {
    class func response(_ request: URLRequest, complete: @escaping (Data) -> Void) {
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            
            // Get data
            let fakeData = "data"
            complete(fakeData.data(using: String.Encoding.utf8)!)
        }
    }
}
class Plugin {
    func process(_ request: URLRequest) -> URLRequest {
        
        // Must override
        return request
    }
}

class LoggerPlugin: Plugin {
    
    override func process(_ request: URLRequest) -> URLRequest {
        
        // Process
        
        // Return
        return request
    }
}

class CredentialPlugin: Plugin {
    
    override func process(_ request: URLRequest) -> URLRequest {
        
        // Process
        
        // Return
        return request
    }
}

class NetworkActivityPlugin: Plugin {
    
    override func process(_ request: URLRequest) -> URLRequest {
        
        // Process
        
        // Return
        return request
    }
}

class NetworkService {
    
    // Plugins
    let logger = LoggerPlugin()
    let credential = CredentialPlugin()
    let activity = NetworkActivityPlugin()
    
    // Cache
    var cache: [String: Any] = [:]
    
    func request(endpoint: String, complete: @escaping (Data) -> Void) {
        
        // Get in cache
        if let data = cache[endpoint] as? Data {
            complete(data)
            return
        }
        
        // Create request
        let request = URLRequest(url: URL(string: endpoint)!)
        
        // Plugins
        processPlugins(request: request)
        
        // Exectue
        Alamofire.response(request) { (data) in
            self.cache[endpoint] = request
            complete(data)
        }
    }
    
    func processPlugins(request: URLRequest) -> URLRequest {
        var _request = request
        _request = logger.process(_request)
        _request = credential.process(_request)
        _request = activity.process(_request)
        return _request
    }
}
