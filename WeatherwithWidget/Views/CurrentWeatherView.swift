//
//  CurrentWeatherView.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/17/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI


fileprivate let currentWeatherViewFontSize: CGFloat = 24


public struct CurrentWeatherView: View {
    @ObservedObject var viewModel: ViewModel


    public var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack {
                    Image(viewModel.weatherIconName)
                        .frame(width: 75, height: 45, alignment: .leading)
                    Text(viewModel.currentConditions)
                        .scaledCurrentWeatherPanelFont()
                        .padding(.top, 5)
                }
                HStack {
                    Image("HighTemp")
                        .resizable()
                        .frame(width: 13, height: 17)
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, 8)
                    Text(viewModel.highTemp)
                        .scaledCurrentWeatherPanelFont()
                        .padding(.trailing, currentWeatherViewFontSize)
                    Image("LowTemp")
                        .resizable()
                        .frame(width: 13, height: 17)
                        .aspectRatio(contentMode: .fit)
                        .padding(.trailing, 8)
                    Text(viewModel.lowTemp)
                        .scaledCurrentWeatherPanelFont()
                        .padding(.trailing, currentWeatherViewFontSize)
                    Spacer()
                }
                HStack {
                    Text(viewModel.temperature)
                    .scaledFont(name: "HelveticaNeue-UltraLight", size: 72)
                }
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


struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView(viewModel: ViewModel())
            .background(Color.blue)
    }
}
