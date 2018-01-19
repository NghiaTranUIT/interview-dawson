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

protocol JSONSerializable {
    func jsonDecode() -> [String: Any]
}

protocol DataSerializable {
    func dataDecode() -> Data
}

protocol NSManagedObjectSerializable {
    func toManagedObject() -> NSManagedObject
}

class UserObj: JSONSerialization, NSManagedObjectSerializable {
    
    private let userInfo: String = ""

    func jsonDecode() -> [String: Any] {
        return ["userInfo": userInfo]
    }
    
    func toManagedObject() -> NSManagedObject {
        return NSManagedObject()
    }
}

class PlaceObj: JSONSerialization, NSManagedObjectSerializable, DataSerializable {
    
    var name: String = ""
    
    func jsonDecode() -> [String: Any] {
        return ["name": name]
    }
    
    func dataDecode() -> Data {
        return name.data(using: String.Encoding.utf8)!
    }
    
    func toManagedObject() -> NSManagedObject {
        return NSManagedObject()
    }
}

class TrackingObj: NSManagedObjectSerializable {
    
    func toManagedObject() -> NSManagedObject {
        return NSManagedObject()
    }
}
