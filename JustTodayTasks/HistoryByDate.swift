//
//  HistoryByDate.swift
//  JustTodayTasks
//
//  Created by Huy Ong on 8/7/20.
//

import SwiftUI

struct HistoryByDate: View {
    @Environment(\.presentationMode) var presentation
    @ObservedObject var model: TaskModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("History")) {
                    ForEach(model.historyTasks, id: \.self) { row in
                        RowViewViewOnly(row: row)
                    }
                    .onMove { (from, to) in
                        model.historyTasks.move(fromOffsets: from, toOffset: to)
                    }
                    .onDelete { (indexSet) in
                        model.historyTasks.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationBarTitle(Text("History"))
            .navigationBarItems(leading: EditButton(),
                                trailing:
                                    Button(action: { presentation.wrappedValue.dismiss() }) { Text("Done") }
            )
        }
    }
}

