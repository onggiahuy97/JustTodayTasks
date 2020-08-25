//
//  RowView.swift
//  JustTodayTasks
//
//  Created by Huy Ong on 8/7/20.
//

import SwiftUI

struct RowView: View {
    @Binding var row: Task
    
    let checkmark = Image(systemName: "checkmark")
    
    var body: some View {
        Button(action: { self.row.isDone.toggle() }) {
            HStack {
                if row.isDone { checkmark } else { checkmark.hidden() }
                Text(row.name).strikethrough(row.isDone)
                Spacer()
                Text(row.date.toString()).font(.subheadline).foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.primary)
        }
    }
}

struct RowViewViewOnly: View {
    var row: Task
    
    var showDate = true
    
    let checkmark = Image(systemName: "checkmark")
    
    var body: some View {
        HStack {
            if row.isDone { checkmark } else { checkmark.hidden() }
            Text(row.name).strikethrough(row.isDone)
            Spacer()
            if !showDate { EmptyView() } else {
                Text(row.date.toString()).font(.subheadline).foregroundColor(.secondary)
            }
        }
    }
}
