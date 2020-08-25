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
    @State private var selection: Tab = .today
    
    var body: some View {
        TabView(selection: $selection) {
            NavigationView {
                SectionView(model: model)
                    .navigationBarTitle(Text("Tasks"))
                    .navigationBarItems(leading: EditButton()
                                            .foregroundColor(.AccentColor()),
                                        trailing:
                                            HStack(spacing: 16) {
                                                Button(action: { self.showHistory = true }) {
                                                    Image(systemName: "arrow.up.bin.fill")
                                                        .imageScale(.large)
                                                }
                                                Button(action: { self.model.isSorting.toggle() }) {
                                                    Image(systemName: "arrow.up.arrow.down.square.fill")
                                                        .imageScale(.large)
                                                }
                                            }
                                            .foregroundColor(.AccentColor())
                    )
                    .sheet(isPresented: $showHistory) {
                        HistoryByDate(model: self.model)
                    }
            }
            .tabItem {
                Label("Today", systemImage: "list.bullet.rectangle")
            }
            .tag(Tab.today)
            
            MonthlyView()
                .tabItem {
                    Label("Monthly", systemImage: "calendar")
                }
                .tag(Tab.monthly)
        }
    }
    
    private enum Tab {
        case monthly, today
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: TaskModel())
    }
}

