//
//  CurrentWeatherView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI

fileprivate let currentWeatherViewFontSize: CGFloat = 16


public struct WidgetSmallForLargeView: View {
    let viewModel: ViewModel
    let height: CGFloat


    public init (viewModel: ViewModel, height: CGFloat) {
        self.viewModel = viewModel
        self.height = height
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Group {
                    HStack {
                        Image(uiImage: viewModel.weatherIcon!)
                            .resizable()
                            .frame(width: 37, height: 22, alignment: .leading)
                            .offset(x: -10)
                            .padding(.top, 5)
                        Text(viewModel.currentConditions)
                            .scaledCurrentWeatherPanelFont()
                            .padding(.top, 5)
                            .padding(.leading, -8)
                        Spacer()
                    }
                    HStack {
                        Image("HighTemp")
                            .resizable()
                            .frame(width: 15, height: 19)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing, 3)
                        Text(viewModel.highTemp)
                            .scaledCurrentWeatherPanelFont()
                            .padding(.trailing, 8)
                        Image("LowTemp")
                            .resizable()
                            .frame(width: 15, height: 19)
                            .aspectRatio(contentMode: .fit)
                            .padding(.trailing, 3)
                        Text(viewModel.lowTemp)
                            .scaledCurrentWeatherPanelFont()
                            .padding(.trailing, 8)
                    }
                }.foregroundColor(.white)
            } .padding(.leading, 20)

            HStack(alignment: .top) {
                Text(viewModel.temperature)
                    .scaledFont(name: "HelveticaNeue-UltraLight", size: height > 140 ? 48 : 32)
                    .frame(maxWidth: .infinity, alignment: height > 140 ? .center : .leading)
                    .foregroundColor(.white)
            }.padding(.leading, 40)
        }
    }
}
