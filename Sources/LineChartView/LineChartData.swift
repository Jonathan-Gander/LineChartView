//
//  LineChartData.swift
//  ChartLineView Package
//
//  Created by Jonathan Gander
//

import Foundation

public struct LineChartData: Hashable {
    public let value: Double
    public let timestamp: Date?
    public let label: String?
    
    public init(_ value: Double, timestamp: Date? = nil, label: String? = nil) {
        self.value = value
        self.timestamp = timestamp
        self.label = label
    }
}
