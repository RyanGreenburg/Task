//
//  CoreDataStack.swift
//  Task
//
//  Created by RYAN GREENBURG on 1/30/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataStack {
    static let container: NSPersistentContainer = {
        
        let appName = Bundle.main.object(forInfoDictionaryKey: (kCFBundleNameKey as String)) as! String
        let container = NSPersistentContainer(name: appName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error loading persistent stores \(error) : \(error.localizedDescription)")
            }
        })
        return container
    }()
    static var context: NSManagedObjectContext { return container.viewContext}
}
