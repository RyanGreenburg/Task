//
//  Task+Convenience.swift
//  Task
//
//  Created by RYAN GREENBURG on 1/30/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    @discardableResult
    convenience init(name: String, notes: String?, due: Date?, isComplete: Bool, managedObjectContext: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: managedObjectContext)
        self.name = name
        self.notes = notes
        self.due = due
        self.isComplete = isComplete
    }
}
