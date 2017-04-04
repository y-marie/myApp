//
//  DIARY+CoreDataProperties.swift
//  myApp
//
//  Created by 有希 on 2017/04/04.
//  Copyright © 2017年 Yuki Mitsudome. All rights reserved.
//

import Foundation
import CoreData


extension DIARY {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DIARY> {
        return NSFetchRequest<DIARY>(entityName: "DIARY")
    }

    @NSManaged public var saveDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var image1: String?
    @NSManaged public var image2: String?
    @NSManaged public var date: NSDate?

}
