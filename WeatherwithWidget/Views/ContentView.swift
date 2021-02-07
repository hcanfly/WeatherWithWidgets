//
//  ContentView.swift
//  WeatherwithWidget
//
//  Created by Gary on 6/28/20.
//

import SwiftUI
import WidgetKit
import os.log


struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var scrollViewOffset: CGPoint = .zero
    @Environment(\.scenePhase) var scenePhase

    let panelHeight: CGFloat = 120
    let cityName = "Mountain View"


    func calcBlurRadius(height: CGFloat) -> CGFloat {
        // blur the background image more as view is scrolled down
        let blur = CGFloat((-self.scrollViewOffset.y / (height * 0.7)) * 15.0)
        return blur
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                Image("BlueSky")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    // need frame to constrain geometry bounds on some devices
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: self.calcBlurRadius(height: geometry.size.height))
                HStack(alignment: .center) {
                    Text(self.cityName)
                        .font(.title)
                        .foregroundColor(.white)
                }.offset(y: 40)
                OffsetScrollView(.vertical, showsIndicators: false, offset: self.$scrollViewOffset) {
                    VStack(alignment: .center, spacing: 90) {
                        CurrentWeatherView(viewModel: self.viewModel)
                            .frame(width: geometry.size.width, height: panelHeight)
                        DetailsPanelView(viewModel: self.viewModel)
                            .frame(width: geometry.size.width, height: panelHeight)
                            .padding(.bottom, 60)
                        ForecastPanelView(forecast:self.viewModel.forecastInfo())
                            .frame(width: geometry.size.width, height: panelHeight)
                            .padding(.bottom, 60)
                        WindAndPressurePanelView(viewModel: self.viewModel)
                            .frame(width: geometry.size.width, height: panelHeight)
                        Spacer()
                    }.padding(.top, geometry.size.height - geometry.safeAreaInsets.bottom - 230)
                }
                .frame(width: geometry.size.width)
                .offset(y: geometry.safeAreaInsets.top + 54)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // testing to see how often this gets hit. remove before release.
            os_log("app onAppear getting weather", log: OSLog.networkLogger, type: .info)
            self.viewModel.getWeather()
        }
        .onChange(of: scenePhase) { phase in 
            if phase == .active {
                // testing to see how often this gets hit. remove before release.
                os_log("app becoming active getting weather", log: OSLog.networkLogger, type: .info)
                self.viewModel.getWeather()
            } else if phase == .inactive {
                os_log("telling widget to refresh", log: OSLog.networkLogger, type: .info)
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: ViewModel())
    }
}
