//
//  Device+CoreDataProperties.swift
//  CoreData_TestApplication
//
//  Created by Robert Byrne on 2015-12-03.
//  Copyright © 2015 Razeware LLC. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Device {

    @NSManaged var deviceType: String
    @NSManaged var name: String

}
