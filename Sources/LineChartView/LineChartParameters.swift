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
    
    public enum DisplayMode {
        case `default`
        case noValues // Display 'label' instead of 'value' (from LineChartData) in main label
    }
    
    // MARK: - Data
    private var data: [LineChartData]
    
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
    
    public var displayMode: DisplayMode
    
    // MARK: - Interactions
    public var dragGesture: Bool = true
    public var hapticFeedback: Bool = false
    
    
    // MARK: - Computed properties
    var dataValues: [Double] {
        data.map({ $0.value })
    }
    
    var dataLabels: [String?] {
        data.map({ $0.label })
    }
    
    var dataTimestamps: [Date]? {
        let allTimestamps = data.filter({ $0.timestamp != nil }).map({ $0.timestamp! })
        if allTimestamps.count == dataValues.count {
            return allTimestamps
        }
        return nil
    }
    
    public init (
        data: [LineChartData],
        
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
        
        displayMode: DisplayMode = .default,
        
        dragGesture: Bool = true,
        hapticFeedback: Bool = false
    ) {
        self.data = data
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
        self.displayMode = displayMode
        self.dragGesture = dragGesture
        self.hapticFeedback = hapticFeedback
    }
}
