//
//  Note+CoreDataProperties.swift
//  R_Notes2
//
//  Created by hiirari on 26.02.2024.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var id: UUID!
    @NSManaged public var text: String!
    @NSManaged public var lastUpdated: Date!

}
extension Note: Identifiable {

}
