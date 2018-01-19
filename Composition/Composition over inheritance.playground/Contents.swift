//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

// -----------------------
// User obj
// + JSON decode
// + Transform to NSManagedObject

// -----------------------
// PlaceObj
// + JSON encode
// + Data encode
// + Transform to NSManagedObject

// -----------------------
// TrackingObj
// + Transform to NSManagedObject

class NSManagedObject {}

class BaseObject {
    
    func jsonDecode() -> [String: Any]? {
        // Need Override
        return nil
    }
    
    func dataDecode() -> Data? {
        // Need Override
        return nil
    }
    
    func tranformToNSManagedObject() -> NSManagedObject? {
        // Need Override
        return nil
    }
}

class UserObj: BaseObject {
    
    private let userInfo: String = ""
    
    override func jsonDecode() -> [String : Any]? {
        return ["userInfo": userInfo]
    }
    
    override func tranformToNSManagedObject() -> NSManagedObject? {
        return NSManagedObject()
    }
}

class PlaceObj: BaseObject {
    
    let name: String = ""
    
    override func jsonDecode() -> [String : Any]? {
        return ["name": name]
    }
    
    override func dataDecode() -> Data? {
        return name.data(using: String.Encoding.utf8)
    }
    
    override func tranformToNSManagedObject() -> NSManagedObject? {
        return NSManagedObject()
    }
}

class TrackingObj: BaseObject {
    
    override func tranformToNSManagedObject() -> NSManagedObject? {
        return NSManagedObject()
    }
}
