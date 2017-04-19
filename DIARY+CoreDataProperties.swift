//
//  DIARY+CoreDataProperties.swift
//  myApp
//
//  Created by 有希 on 2017/04/19.
//  Copyright © 2017年 Yuki Mitsudome. All rights reserved.
//

import Foundation
import CoreData


extension DIARY {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DIARY> {
        return NSFetchRequest<DIARY>(entityName: "DIARY")
    }

    @NSManaged public var content: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var image1: String?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var saveDate: NSDate?
    @NSManaged public var title: String?

}
