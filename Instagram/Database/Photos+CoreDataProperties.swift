//
//  Photos+CoreDataProperties.swift
//  Instagram
//
//  Created by Kirti Parghi on 2019-07-05.
//  Copyright © 2019 Kirti Parghi. All rights reserved.
//
//

import Foundation
import CoreData


extension Photos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photos> {
        return NSFetchRequest<Photos>(entityName: "Photos")
    }

    @NSManaged public var imgdata: String?
    @NSManaged public var desc: String?
    @NSManaged public var latitude: String?
    @NSManaged public var longitude: String?
    @NSManaged public var useremail: String?
    @NSManaged public var datetime: String?
    @NSManaged public var photoid: String?
    @NSManaged public var user: User?
    @NSManaged public var comments: NSSet?

}

// MARK: Generated accessors for comments
extension Photos {

    @objc(addCommentsObject:)
    @NSManaged public func addToComments(_ value: Comment)

    @objc(removeCommentsObject:)
    @NSManaged public func removeFromComments(_ value: Comment)

    @objc(addComments:)
    @NSManaged public func addToComments(_ values: NSSet)

    @objc(removeComments:)
    @NSManaged public func removeFromComments(_ values: NSSet)

}
