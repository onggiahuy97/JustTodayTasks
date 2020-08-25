//
//  JustTasksWidget.swift
//  JustTasksWidget
//
//  Created by Huy Ong on 8/9/20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct JustTasksWidgetEntryView : View {
    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        Text(Date(), style: .relative)
    }
}

@main
struct JustTasksWidget: Widget {
    
    let kind: String = "JustTasksWidget"
    
    var tasks: [Task] = []
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
//            JustTasksWidgetEntryView()
            Text("\(tasks.count)")
        }
        .configurationDisplayName("My Widget Tasks")
        .description("Show tasks for today")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct JustTasksWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            JustTasksWidgetEntryView()
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
        }
    }
}
