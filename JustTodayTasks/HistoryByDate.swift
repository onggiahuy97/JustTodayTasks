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
                    ForEach(model.historyTasks.reversed(), id: \.self) { row in
                        RowViewViewOnly(row: row)
                    }
                    .onMove { (from, to) in
                        self.model.historyTasks.move(fromOffsets: from, toOffset: to)
                    }
                    .onDelete { (indexSet) in
                        self.model.historyTasks.remove(atOffsets: indexSet)
                    }
                }
            }
            .navigationBarTitle(Text("History"))
            .navigationBarItems(leading: EditButton().foregroundColor(.AccentColor()),
                                trailing:
                Button(action: { self.presentation.wrappedValue.dismiss() }) { Text("Done") }.foregroundColor(.AccentColor())
            )
        }
    }
}

