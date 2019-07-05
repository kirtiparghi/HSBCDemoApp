//
//  User+CoreDataProperties.swift
//  Instagram
//
//  Created by Kirti Parghi on 2019-07-05.
//  Copyright © 2019 Kirti Parghi. All rights reserved.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var emailid: String?
    @NSManaged public var password: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var photos: NSSet?
}

// MARK: Generated accessors for photos
extension User {

    @objc(addPhotosObject:)
    @NSManaged public func addToPhotos(_ value: Photos)

    @objc(removePhotosObject:)
    @NSManaged public func removeFromPhotos(_ value: Photos)

    @objc(addPhotos:)
    @NSManaged public func addToPhotos(_ values: NSSet)

    @objc(removePhotos:)
    @NSManaged public func removeFromPhotos(_ values: NSSet)
}
