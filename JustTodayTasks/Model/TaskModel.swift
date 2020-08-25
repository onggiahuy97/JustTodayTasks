//
//  TaskModel.swift
//  JustTodayTasks
//
//  Created by Huy Ong on 8/7/20.
//

import Foundation
import Combine

class TaskModel: ObservableObject {

    @Published var tasks: [Task] = [] {
        didSet {
            saveData()
        }
    }
    
    @Published var historyTasks: [Task] = [] {
        didSet {
            saveData()
        }
    }
    
    @Published var isSorting: Bool = false

    var completedTasks: [Task] {
        tasks.filter { $0.isDone }
    }
    
    var activeTasks: [Task] {
        tasks.filter { !$0.isDone }
    }
    
    init() {
        dataDidLoad()
    }
}

extension TaskModel {
    
    static func tasksURL() -> URL {
        return URL(fileURLWithPath: "Tasks",relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first).appendingPathExtension("json")
    }
    
    func saveData() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let allTasks = historyTasks + tasks
            let data = try encoder.encode(allTasks)
            try data.write(to: TaskModel.tasksURL(), options: .atomicWrite)
        } catch let error {
            print(error)
        }
        
    }
    
    func dataDidLoad() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: TaskModel.tasksURL())
            let allTasks = try decoder.decode([Task].self, from: data)
            tasks = allTasks.filter { $0.date.toDay() }
            historyTasks = allTasks.filter { !$0.date.toDay() }
        } catch let error {
            print(error)
        }
    }
}


