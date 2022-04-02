//
//  LineChartParameters.swift
//  ChartLineView Package
//
//  Created by Jonathan Gander
//
//  Notes about this class: I use it to not copy all values ref throw others used structs.
//  It is easier to use (in code) and (a bit) optimized.

import SwiftUI

public class LineChartParameters {
    
    // MARK: - Data
    public var data: [Double]
    public var dataTimestamps: [Date]?
    public var dataLabels: [String]?
    
    // MARK: - Style
    public var labelColor: Color
    public var secondaryLabelColor: Color
    public var labelsAlignment: ChartLabels.Alignment
    
    public var dataPrecisionLength: Int
    
    public var dataPrefix: String?
    public var dataSuffix: String?
    
    public var indicatorPointColor: Color
    public var indicatorPointSize: CGFloat
    
    public var lineColor: Color
    public var lineSecondColor: Color
    public var lineWidth: CGFloat
    
    public var dotsWidth: CGFloat
    
    // MARK: - Interactions
    public var dragGesture: Bool = true
    public var hapticFeedback: Bool = false
    
    public init(
        data: [Double],
        dataTimestamps: [Date]? = nil, // A timestamp for each data value. If set, will draw x values according to timestamps. This array has to have exact same number of items as data array.
        dataLabels: [String]? = nil,
        
        labelColor: Color = .primary,
        secondaryLabelColor: Color = .secondary,
        labelsAlignment: ChartLabels.Alignment = .left,
        
        dataPrecisionLength: Int = 2, // Only available on iOS 15+
        
        dataPrefix: String? = nil, // Text displayed before data
        dataSuffix: String? = nil, // Text displayed after data
        
        indicatorPointColor: Color = .blue,
        indicatorPointSize: CGFloat = 20,
        
        lineColor: Color = .blue,
        lineSecondColor: Color? = nil,
        lineWidth: CGFloat = 3,
        
        dotsWidth: CGFloat = -1, // Set it to a value > 0 to display dots
        
        dragGesture: Bool = true,
        hapticFeedback: Bool = false
    ) {
        self.data = data
        
        // dataTimestamps must have same number of items than data array
        if dataTimestamps != nil && dataTimestamps!.count == data.count {
            self.dataTimestamps = dataTimestamps
        }
        
        self.dataLabels = dataLabels
        self.labelColor = labelColor
        self.secondaryLabelColor = secondaryLabelColor
        self.labelsAlignment = labelsAlignment
        self.dataPrecisionLength = dataPrecisionLength
        self.dataPrefix = dataPrefix
        self.dataSuffix = dataSuffix
        self.indicatorPointColor = indicatorPointColor
        self.indicatorPointSize = indicatorPointSize
        self.lineColor = lineColor
        self.lineSecondColor = lineSecondColor == nil ? lineColor : lineSecondColor!
        self.lineWidth = lineWidth
        self.dotsWidth = dotsWidth
        self.dragGesture = dragGesture
        self.hapticFeedback = hapticFeedback
    }
}
