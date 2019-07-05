//
//  Comment+CoreDataProperties.swift
//  Instagram
//
//  Created by Kirti Parghi on 2019-07-05.
//  Copyright © 2019 Kirti Parghi. All rights reserved.
//
//

import Foundation
import CoreData


extension Comment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comment> {
        return NSFetchRequest<Comment>(entityName: "Comment")
    }

    @NSManaged public var commentid: String?
    @NSManaged public var commentdesc: String?
    @NSManaged public var photoid: String?
    @NSManaged public var datetime: String?
    @NSManaged public var username: String?
    @NSManaged public var photo: Photos?
}
