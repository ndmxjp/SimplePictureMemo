//
//  Note+CoreDataProperties.swift
//  PictureMemo
//
//  Created by saito-takumi on 2016/04/28.
//  Copyright © 2016年 saito-takumi. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Note {

    @NSManaged var title: String?
    @NSManaged var image: Data?
    @NSManaged var memo: String?
    @NSManaged var date: Date?

}
