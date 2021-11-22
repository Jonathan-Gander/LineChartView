//
//  ChartIndicatorPoint.swift
//  ChartLineView Package
//
//  Created by Jonathan Gander
//

import SwiftUI

public struct ChartIndicatorPoint: View {
    public var lineChartParameters: LineChartParameters
    
    public var body: some View {
        Circle()
            .fill(lineChartParameters.indicatorPointColor)
            .frame(width: lineChartParameters.indicatorPointSize, height: lineChartParameters.indicatorPointSize)
            .shadow(color: .black, radius: 10, x: 0, y: 0)
            .overlay(
                Circle()
                    .stroke(.white, lineWidth: 3.0)
            )
    }
}
