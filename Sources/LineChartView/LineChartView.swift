//
//  LineChartView.swift
//  ChartLineView Package
//
//  Created by Jonathan Gander
//

import SwiftUI

public struct LineChartView: View {
    public var lineChartParameters: LineChartParameters
    
    @State var showingIndicators = false
    @State var indexPosition = Int()
    
    public init(lineChartParameters: LineChartParameters) {
        self.lineChartParameters = lineChartParameters
    }
    
    public var body: some View {
        if lineChartParameters.dataValues.count > 0 {
            VStack {
                if lineChartParameters.dragGesture {
                    ChartLabels(lineChartParameters: lineChartParameters, indexPosition: $indexPosition)
                        .opacity(showingIndicators ? 1: 0)
                }
                
                LineView(
                    lineChartParameters: lineChartParameters,
                    showingIndicators: $showingIndicators,
                    indexPosition: $indexPosition
                )
                    .padding(.top, 10)
            }
            .padding()
        }
    }
}
