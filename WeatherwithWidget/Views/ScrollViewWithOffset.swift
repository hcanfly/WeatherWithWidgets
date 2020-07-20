//
//  ScrollViewWithOffset.swift
//  WeatherSwiftUI
//
//  Created by Gary on 2/21/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

// from Zac White: https://zacwhite.com/2019/scrollview-content-offsets-swiftui/



import SwiftUI

public struct OffsetScrollView<Content>: View where Content : View {

    /// The content of the scroll view.
    public var content: Content

    /// The scrollable axes.
    ///
    /// The default is `.vertical`.
    public var axes: Axis.Set

    /// If true, the scroll view may indicate the scrollable component of
    /// the content offset, in a way suitable for the platform.
    ///
    /// The default is `true`.
    public var showsIndicators: Bool

    /// The initial offset in the global frame, used for calculating the relative offset
    @State private var initialOffset: CGPoint? = nil

    /// The offset of the scrollview updated as the scroll view scrolls
    @Binding public var offset: CGPoint

    public init(_ axes: Axis.Set = .vertical, showsIndicators: Bool = true, offset: Binding<CGPoint> = .constant(.zero), @ViewBuilder content: () -> Content) {
        self.axes = axes
        self.showsIndicators = false    //always want this
        self._offset = offset
        self.content = content()
    }

    /// Declares the content and behavior of this view.
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            VStack(alignment: .leading, spacing: 0) {
                GeometryReader { geometry in
                    Run {
                        let globalOrigin = geometry.frame(in: .global).origin
                        self.initialOffset = self.initialOffset ?? globalOrigin
                        let initialOffset = (self.initialOffset ?? .zero)
                        let offset = CGPoint(x: globalOrigin.x - initialOffset.x, y: globalOrigin.y - initialOffset.y)
                        self.offset = offset
                    }
                }.frame(width: 0, height: 0)

                content
            }
        }
    }
}


struct Run: View {
    let block: () -> Void

    var body: some View {
        DispatchQueue.main.async(execute: block)
        return AnyView(EmptyView())
    }
}


