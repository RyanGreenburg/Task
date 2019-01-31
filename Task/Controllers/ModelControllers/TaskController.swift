//
//  TaskController.swift
//  Task
//
//  Created by RYAN GREENBURG on 1/30/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications

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
    
    init() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("error loading fetched results: \(error) : \(error.localizedDescription)")
        }
    }
    
    // MARK: - CRUD Functions
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
            task.isComplete = true; self.cancelLocalNotification(for: task)
        } else {
            task.isComplete = false; self.scheduleUserNotifications(for: task)
        }
        saveToPersistenceStore()
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

extension TaskController {
    func scheduleUserNotifications(for task: Task) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = UNNotificationSound.default
        notificationContent.title = "\(task.name ?? "Task Due")"
        notificationContent.body = "Your task is due!"
        notificationContent.badge = 1
        
        guard let dueDate = task.due,
            let uuid = task.uuid else{ return }
        
        let fireDate = dueDate
        let dateComponents = Calendar.current.dateComponents([.month, .day], from: fireDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: uuid, content: notificationContent, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancelLocalNotification(for task: Task) {
        guard let uuid = task.uuid else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [uuid])
    }
}
