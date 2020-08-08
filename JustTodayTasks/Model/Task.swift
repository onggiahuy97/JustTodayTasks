//
//  Task.swift
//  JustTodayTasks
//
//  Created by Huy Ong on 8/7/20.
//

import Foundation

struct Task: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var isDone: Bool
    var date: Date
}

