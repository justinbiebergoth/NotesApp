//
//  Note+CoreDataClass.swift
//  R_Notes2
//
//  Created by hiirari on 26.02.2024.
//
//

import Foundation
import CoreData

@objc(Note)
public class Note: NSManagedObject {
    var title: String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first ?? ""
    }

    var desc: String {
        var lines = text.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
        lines.removeFirst()

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short

        return "\(dateFormatter.string(from: lastUpdated)) \(lines.first ?? "")"
    }
}
