//
//  CurrentWeatherView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI

fileprivate let currentWeatherViewFontSize: CGFloat = 16


public struct WidgetSmallView: View {
    let viewModel: ViewModel
    let height: CGFloat


    public init (viewModel: ViewModel, height: CGFloat) {
        self.viewModel = viewModel
        self.height = height
     }

    public var body: some View {
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
                HStack {
                    Text(viewModel.temperature)
                        .scaledFont(name: "HelveticaNeue-UltraLight", size: height > 140 ? 48 : 32)
                        .frame(maxWidth: .infinity, alignment: height > 140 ? .center : .leading)
                }
                .offset(y: height - (height > 140 ? 150 : 110))
            }.foregroundColor(.white)
        } .padding(.leading, 20)
    }
}

struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var size: CGFloat

    func body(content: Content) -> some View {
       let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.custom(name, size: scaledSize))
    }
}

extension View {
    func scaledFont(name: String, size: CGFloat) -> some View {
        return self.modifier(ScaledFont(name: name, size: size))
    }

    func scaledCurrentWeatherPanelFont() -> some View {
        return self.modifier(ScaledFont(name: panelViewFontName, size: currentWeatherViewFontSize))
    }
}

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: alpha )
    }
}
