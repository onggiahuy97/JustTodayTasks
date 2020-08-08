//
//  Date+Extension.swift
//  JustTodayTasks
//
//  Created by Huy Ong on 8/7/20.
//

import Foundation

extension Date {
    func toDay() -> Bool {
        let today = Calendar.current.isDateInToday(self)
        return today
    }
}
