//
//  Device.swift
//  myDevices
//
//

import Foundation
import CoreData

class Device: NSManagedObject {
    
    var deviceDescription: String {
        return "\(name) (\(deviceType))"
    }
    
}
