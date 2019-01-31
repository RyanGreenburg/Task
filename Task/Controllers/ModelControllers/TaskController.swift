//
//  TaskController.swift
//  Task
//
//  Created by RYAN GREENBURG on 1/30/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CoreData

class TaskController {
    
    // Shared instance
    static let shared = TaskController()
    
    // Source of truth
    
    let fetchedResultsController: NSFetchedResultsController<Task> = {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        let isCompleteSort = NSSortDescriptor(key: "isComplete", ascending: false)
        let isDueSort = NSSortDescriptor(key: "due", ascending: false)
        fetchRequest.sortDescriptors = [isCompleteSort, isDueSort]
        
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.context, sectionNameKeyPath: "isComplete", cacheName: nil)
        
    }()
    
    // MARK: - CRUD Functions
    
    init() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error loading fetched results: \(error) : \(error.localizedDescription)")
        }
    }
    // Create
    func add(taskWithName name: String, notes: String?, due: Date?) {
        Task(name: name, notes: notes, due: due, isComplete: false)
        saveToPersistenceStore()
    }
    
    // Read
    
    // Update
    func update(task: Task, name: String, notes: String?, due: Date?) {
        task.name = name
        task.notes = notes
        task.due = due
        saveToPersistenceStore()
    }
    
    // Step 3 Fix this... if/else needed
    func toggleIsCompleteFor(task: Task) {
        if task.isComplete == false {
            task.isComplete = true
        } else {
            task.isComplete = false
        }
        //        switch task.isComplete {
        //        case true: task.isComplete = false
        //        case false: task.isComplete = true
        //        }
    }
    
    // Delete
    func remove(task: Task) {
        if let moc = task.managedObjectContext {
            moc.delete(task)
            saveToPersistenceStore()
        }
    }
    
    // MARK: - Persistence
    // Save
    func saveToPersistenceStore() {
        do {
            try CoreDataStack.context.save()
        } catch {
            print("Error saving to persistent store: \(error.localizedDescription)")
        }
    }
}

