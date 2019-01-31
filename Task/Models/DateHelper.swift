//
//  DateHelper.swift
//  Task
//
//  Created by RYAN GREENBURG on 1/30/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import Foundation

extension Date {
    func stringValue() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: self)
    }
}
