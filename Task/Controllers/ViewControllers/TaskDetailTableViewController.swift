//
//  TaskDetailTableViewController.swift
//  Task
//
//  Created by RYAN GREENBURG on 1/30/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class TaskDetailTableViewController: UITableViewController {
    
    var task: Task? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var dueDateValue: Date?
    
    @IBOutlet weak var taskNameLabel: UITextField!
    @IBOutlet weak var dueDateLabel: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet var dueDatePicker: UIDatePicker!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dueDateLabel.inputView = dueDatePicker
        updateViews()
    }
    
    @IBAction func userTappedView(_ sender: Any) {
        resignFirstResponder()
    }
    
    @IBAction func newTaskSaveButtonTapped(_ sender: Any) {
       updateTask()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func taskCancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        dueDateValue = sender.date
        dueDateLabel.text = dueDateValue?.stringValue()
    }
    
    
    func updateViews() {
        guard let task = task else { return }
        let date = task.due?.stringValue()
        taskNameLabel.text = task.name
        dueDateLabel.text = date
        notesTextView.text = task.notes
        title = task.name
    }
    
    func updateTask() {
        guard let name = taskNameLabel.text else { return }
        let notes = notesTextView.text
        
        if let task = task {
            TaskController.shared.update(task: task, name: name, notes: notes, due: dueDateValue)
        } else {
            TaskController.shared.add(taskWithName: name, notes: notes, due: dueDateValue)
        }
    }    
}
