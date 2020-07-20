//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Gary on 6/28/20.
//

import WidgetKit
import SwiftUI


struct WeatherEntry: TimelineEntry {
    let date: Date
    let viewModel: ViewModel!
}

struct CurrentWidgetProvider: TimelineProvider {

    let viewModel = ViewModel()

    // short-lived widget, such as widget selection menu
    // use placeholder if necessary
    func snapshot(with context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(date: Date(), viewModel: ViewModel())
        completion(entry)
    }

    // normal usage
    func timeline(with context: Context, completion: @escaping (Timeline<WeatherEntry>) -> ()) {
            viewModel.getWeather { viewModel in
                let entry = WeatherEntry(date: Date(), viewModel: viewModel)
                let timeline = Timeline(entries: [entry], policy: .never)
                completion(timeline)
            }
    }
}


struct PlaceholderView : View {
    var body: some View {
        Image("Clouds")
    }
}

struct WeatherWidgetEntryView : View {
    let viewModel: ViewModel
    let height: CGFloat

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
                    Text("Medium Widget View 2")
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
        StaticConfiguration(kind: "WeatherSwiftUI",
                            provider: CurrentWidgetProvider(),
                            placeholder: PlaceholderView()) { entry in
            GeometryReader { metrics in
                WeatherWidgetEntryView(viewModel: entry.viewModel, height: metrics.size.height)
            }
        }
        .configurationDisplayName("Weather")
        .description("Weather info for Mountain View, CA, USA")
//        .supportedFamilies([.systemSmall, .systemLarge])      // couldn't find a medium design I liked. maybe later
        .supportedFamilies([.systemLarge])  // testing
    }
}

