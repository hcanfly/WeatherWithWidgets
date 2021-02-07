//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Gary on 6/28/20.
//

import WidgetKit
import SwiftUI
import os.log

var lastUpdateTime = Date()

struct WeatherEntry: TimelineEntry {
    let date: Date
    let viewModel: ViewModel!
}

struct CurrentWidgetProvider: TimelineProvider {
    typealias Entry = WeatherEntry
    

    let viewModel = ViewModel()

    // short-lived widget, such as widget selection menu
    // use placeholder if necessary
    func getSnapshot(in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(date: Date(), viewModel: ViewModel())
        completion(entry)
    }

    // normal usage
    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherEntry>) -> Void) {

        // we're getting called twice. don't want to make duplicate calls and use up free api calls
        let differenceInSeconds = Int(Date().timeIntervalSince(lastUpdateTime))
        if differenceInSeconds < 5 {
            viewModel.getWeather { viewModel in
                // testing to see how often this gets hit. remove before release.
                os_log("widget getting weather", log: OSLog.networkLogger, type: .info)

                let entry = WeatherEntry(date: Date(), viewModel: viewModel)
                // make sure that we get refreshed
                // to be really usefull to the user it would be better to do this more like
                // every 15 minutes. But, that would be more api calls per day than we get
                let refreshDate = Calendar.current.date(byAdding: .minute, value: 60, to: Date())
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate!))
                completion(timeline)
            }
        }
        lastUpdateTime = Date()

    }

    func placeholder(in context: Context) -> WeatherEntry {
        return WeatherEntry(date: Date(), viewModel: viewModel)
    }
}


struct PlaceholderView : View {
    var body: some View {
        Image("Clouds")
    }
}

fileprivate func showLog() -> Bool
{
    os_log("widget displaying view", log: OSLog.networkLogger, type: .info)
    return true
}

struct WeatherWidgetEntryView : View {
    let viewModel: ViewModel
    let height: CGFloat
    let notUsed = showLog()

    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        ZStack(alignment: .top) {
            Image("BlueSky")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
            switch family {
            case .systemSmall:
                WidgetSmallView(viewModel: viewModel, height: height)
            case .systemMedium:
                VStack {
                    Text("Medium Widget View")
                    Spacer()
                    Text("Medium Widget View Part 2")
                }
            case .systemLarge:
                WidgetLargeView(viewModel: viewModel, height: height)

            @unknown default:
                fatalError()
            }
        }
    }
}

struct CurrentWeatherWidget: Widget {
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: "com.gary.weatherwidget",
                            provider: CurrentWidgetProvider()) { entry in
            GeometryReader { metrics in
                WeatherWidgetEntryView(viewModel: entry.viewModel, height: metrics.size.height)
            }
        }
        .configurationDisplayName("Weather")
        .description("Weather info for Mountain View, CA, USA")
//        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        .supportedFamilies([.systemSmall, .systemLarge])    // couldn't find a medium design I liked. maybe later
    }
}

