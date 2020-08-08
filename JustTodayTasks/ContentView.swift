//
//  ContentView.swift
//  Shared
//
//  Created by Huy Ong on 8/5/20.
//

import SwiftUI
import Foundation
import Combine

struct ContentView: View {
    @ObservedObject var model: TaskModel
    @State private var showHistory = false
    
    var body: some View {
        NavigationView {
            SectionView(model: model)
                .navigationBarTitle(Text("Tasks"))
                .navigationBarItems(leading: EditButton(), trailing:
                                        HStack(spacing: 16) {
                                            Button(action: { showHistory = true }) {
                                                Image(systemName: "xmark.bin.fill")
                                                    .imageScale(.large)
                                            }
                                            Button(action: { model.isSorting.toggle() }) {
                                                Image(systemName: "arrow.up.arrow.down.square.fill")
                                                    .imageScale(.large)
                                            }
                                        }
                                    )
//                .toolbar(items: {
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        EditButton()
//                    }
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        HStack(spacing: 16) {
//                            Button(action: { showHistory = true }) {
//                                Image(systemName: "xmark.bin.fill")
//                                    .imageScale(.large)
//                            }
//                            Button(action: { model.isSorting.toggle() }) {
//                                Image(systemName: "arrow.up.arrow.down.square.fill")
//                                    .imageScale(.large)
//                            }
//                        }
//                    }
//                })
        }
        .sheet(isPresented: $showHistory) {
            HistoryByDate(model: model)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: TaskModel())
    }
}
