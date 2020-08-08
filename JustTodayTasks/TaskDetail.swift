//
//  TaskDetail.swift
//  JustTodayTasks
//
//  Created by Huy Ong on 8/7/20.
//

import SwiftUI

struct TaskDetail: View {
    @Binding var task: Task
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $task.name)
                Toggle("Complete", isOn: $task.isDone)
            }
        }
        .navigationBarTitle(Text(task.name))
    }
}
