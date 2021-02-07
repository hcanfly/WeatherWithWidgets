//
//  WidgetLargeView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI

let panelViewFontName = "Helvetica Neue"
let panelViewFontSize: CGFloat = 18
let panelBackgroundColor = Color(UIColor(hex: 0x000049, alpha: 0.1))


struct WidgetLargeView: View {
    @ObservedObject var viewModel: ViewModel
    let forecast: [ForecastInfo]
    let height: CGFloat

    init(viewModel: ViewModel, height: CGFloat) {
        self.viewModel = viewModel
        self.forecast = viewModel.forecastInfo()
        self.height = height
    }

    var body: some View {
        VStack(spacing: 4) {
            WidgetSmallForLargeView(viewModel: viewModel, height: height * 0.3)
                .frame(height: height * 0.3)
                //.padding(.bottom, 4)
            Group {
                if (self.forecast.count > 0) {
                    VStack {
                        PanelHeaderView(title: "Forecast")
                            .background(panelBackgroundColor)
                            .foregroundColor(.white)
                        VStack(alignment: .leading, spacing: 0) {
                            Group {
                                ForEach((0...4), id: \.self) {
                                    WidgetForecastDayView(dailyWeather: self.forecast[$0])
                                }
                            }
                            .foregroundColor(.white)
                            .background(panelBackgroundColor)
                        }
                    }
                    .padding(.bottom, 20)
                    Spacer()
                } else {
                    Spacer()
                    VStack {
                        Text("No data")
                    }
                    .padding(.bottom, 10)
                    .background(panelBackgroundColor)
                }
            }
        }
    }
}


struct WidgetForecastDayView: View {
    var dailyWeather:  ForecastInfo

    var body: some View {
        HStack {
            Text(dailyWeather.dow)
                .scaledPanelFont()
                .frame(width: 110, alignment: .leading)
            Spacer()
            Image(dailyWeather.icon)
                .resizable()
                .clipped()
                .frame(width: 50)
                .aspectRatio(1.6666666, contentMode: .fit)
            Spacer()
            Text(dailyWeather.max)
                .scaledPanelFont()
            Text(dailyWeather.min)
                .scaledPanelFont()
        }.padding(.leading, 20)
        .padding(.trailing, 20)
    }
}

struct PanelHeaderView: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .scaledPanelFont(size: 24)
                .padding(.top, 6)
                .padding(.leading, 10)
            Spacer()

        }.padding(.bottom, 2)
    }
}

extension View {

    func scaledPanelFont(size: CGFloat = panelViewFontSize) -> some View {
        return self.modifier(ScaledFont(name: panelViewFontName, size: size))
    }
}
