//
//  WidgetBundle.swift
//  Shared
//
//  Created by Gary on 6/28/20.
//

import SwiftUI
import WidgetKit


@main
struct TubeWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        CurrentWeatherWidget()
    }
}


