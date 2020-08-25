//
//  SectionView.swift
//  JustTodayTasks
//
//  Created by Huy Ong on 8/7/20.
//

import SwiftUI

struct SectionView: View {
    @ObservedObject var model: TaskModel
    @State private var text: String = ""
    
    var body: some View {
        Form {
            if !model.isSorting {
                NewTaskView
                List {
                    ForEach(model.tasks.indices, id: \.self) { index in
                        RowView(row: self.$model.tasks[index])
                    }
                    .onMove { (from, to) in
                        self.model.tasks.move(fromOffsets: from, toOffset: to)
                    }
                    .onDelete { indexSet in
                        self.model.tasks.remove(atOffsets: indexSet)
                    }
                }
            } else {
                Section(header: Text("Active")) {
                    SortSessionView(activeTasks: model.activeTasks)
                }
                Section(header: Text("Completed")) {
                    SortSessionView(completedTasks: model.completedTasks)
                }
            }
        }
    }
    
    var NewTaskView: some View {
        HStack {
            Image(systemName: "person").hidden()
            TextField("New task", text: $text)
            Image(systemName: "plus.square.fill").imageScale(.large).foregroundColor(.green).onTapGesture {
                self.addTask()
            }
        }
    }
    
    private func addTask() {
        guard text != "" else { return }
        model.tasks.append(.init(name: text, isDone: false, date: Date()))
        text = ""
        endEditting()
    }
}

struct SortSessionView: View {
    var completedTasks: [Task] = []
    var activeTasks: [Task] = []
    
    var body: some View {
        List {
            ForEach(completedTasks) { row in
                RowViewViewOnly(row: row)
            }
            ForEach(activeTasks) { row in
                RowViewViewOnly(row: row)
            }
        }
    }
}
