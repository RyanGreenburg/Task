//
//  ButtonTableViewCell.swift
//  Task
//
//  Created by RYAN GREENBURG on 1/30/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    var task: Task?
    
    // Step 2
    weak var delegate: ButtonTableViewCellDelegate?
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonTapped(_ sender: Any) {
       delegate?.buttonCellButtonTapped(self)
    }
    
    func updateButton(_ isComplete: Bool) {
        guard let task = task else { return }
        
        if task.isComplete == false {
            completeButton.setImage(UIImage(named: "incomplete"), for: .normal)
        } else if task.isComplete == true {
            completeButton.setImage(UIImage(named: "complete"), for: .normal)
        }
    }
}

extension ButtonTableViewCell {
    func update(withTask task: Task) {
        self.task = task
        primaryLabel.text = task.name
        updateButton(task.isComplete)
    }
}

// Step 1
protocol ButtonTableViewCellDelegate: class {
    func buttonCellButtonTapped(_ sender: ButtonTableViewCell)
}
