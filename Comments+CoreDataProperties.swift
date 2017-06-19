//
//  Comments+CoreDataProperties.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-03-10.
//  Copyright © 2017 Koki. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Comments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Comments> {
        return NSFetchRequest<Comments>(entityName: "Comments");
    }

    @NSManaged public var comment: String?
    @NSManaged public var number: Int16
    @NSManaged public var skillname: Skills?

}
