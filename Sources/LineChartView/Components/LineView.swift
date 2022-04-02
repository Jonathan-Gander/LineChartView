//
//  LineView.swift
//  ChartLineView Package
//
//  Created by Jonathan Gander
//

import SwiftUI

public struct LineView: View {
    public var lineChartParameters: LineChartParameters
    
    public var data: [Double] = []
    
    @Binding var showingIndicators: Bool
    @Binding var indexPosition: Int
    @State var IndicatorPointPosition: CGPoint = .zero
    
    @State var pathPoints = [CGPoint]()
    
    public var gradient: LinearGradient
    
    // For haptic feedback (detection)
    @State public var currentPreviousPoint: CGPoint?
    @State public var isOnLimits: Bool = false
    
    public init(lineChartParameters: LineChartParameters, showingIndicators: Binding<Bool>, indexPosition: Binding<Int>) {
        self.lineChartParameters = lineChartParameters
        self._showingIndicators = showingIndicators
        self._indexPosition = indexPosition
        
        self.gradient = LinearGradient(gradient: Gradient(colors: [lineChartParameters.lineColor, lineChartParameters.lineSecondColor]),
                                       startPoint: .leading,
                                       endPoint: .trailing)
        
        data = normalize(data: lineChartParameters.data)
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { proxy in
                LinePath(data: data,
                         width: proxy.size.width, height: proxy.size.height,
                         dotsSize: lineChartParameters.dotsWidth,
                         lineWidth: lineChartParameters.lineWidth,
                         pathPoints: $pathPoints,
                         pathTimestamps: lineChartParameters.dataTimestamps)
                    .stroke(gradient, lineWidth: lineChartParameters.lineWidth)
            }
            
            if showingIndicators {
                ChartIndicatorPoint(lineChartParameters: lineChartParameters)
                    .position(x: IndicatorPointPosition.x, y: IndicatorPointPosition.y)
            }
        }
        .rotationEffect(.degrees(180), anchor: .center)
        .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
        .contentShape(Rectangle())  // Control tappable area
        .gesture(lineChartParameters.dragGesture ?
            LongPressGesture(minimumDuration: 0.0)
                .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
                .onChanged({ value in  // Get value of the gesture
                    switch value {
                    case .second(true, let drag):
                        if let longPressLocation = drag?.location {
                            dragGesture(longPressLocation)
                        }
                    default:
                        break
                    }
                })
                // Hide indicator when finish
                .onEnded({ value in
                    self.currentPreviousPoint = nil
                    self.showingIndicators = false
                })
            : nil  // On dragGesture = false
        )
    }
    
    /*
     Get data -> normalize it -> 0 <= output <= 1
     */
    public func normalize(data: [Double]) -> [Double] {
        var normalData = [Double]()
        let min = data.min()!
        let max = data.max()!

        for value in data {
            if max - min != 0 {
                normalData.append((value - min) / (max - min))
            }
            else {
                normalData.append(0.5)
            }
        }
        
        return normalData
    }
    
    /*
     When the user drag on Path -> Modifiy indicator point to move it on the path accordingly
     */
    public func dragGesture(_ longPressLocation: CGPoint) {
        
        // Handle when chart has only one value
        if pathPoints.count == 1 {
            let x = pathPoints[0].x
            let y = pathPoints[0].y
            
            self.IndicatorPointPosition.x = x
            self.IndicatorPointPosition.y = y
            
            self.showingIndicators = true
            self.indexPosition = 0
            
            return;
        }
        
        var x = longPressLocation.x
        
        // Chart bounds: keep x gesture location on limits (left = 0, right = max x)
        if x < 0 {
            x = 0
        }
        if x > pathPoints.last!.x {
            x = pathPoints.last!.x
        }
        
        // Find previous and next point in chart from current x gesture location
        var previousPoint = pathPoints[0]
        var nextPoint = previousPoint
        var index = 0
        for point in pathPoints {
            if x >= point.x {
                previousPoint = point
            }
            if x <= point.x {
                nextPoint = point
                break
            }
            
            index += 1
        }
        
        // Indicator is on left or right limit
        // (prevent divide by 0 on next lines)
        guard previousPoint != nextPoint else {
            
            // Detect when arriving on limit (for haptic feedback)
            if lineChartParameters.hapticFeedback && !isOnLimits {
                isOnLimits = true
                playHapticFeedback()
            }
            return
        }
        
        // If here, indicator is moving on line (so it's in limits)
        isOnLimits = false
        
        // Check if indicator is on exact position (when changing previous point)
        // To play haptic feedback
        if lineChartParameters.hapticFeedback {
            if currentPreviousPoint == nil {
                currentPreviousPoint = previousPoint
            }
            else if previousPoint != currentPreviousPoint {
                currentPreviousPoint = previousPoint
                playHapticFeedback()
            }
        }
        
        // Find y position on chart from: y = mx + b
        // Used to place indicator point
        let m = (previousPoint.y - nextPoint.y) / (previousPoint.x - nextPoint.x)
        let b = previousPoint.y - (m * previousPoint.x)
        self.IndicatorPointPosition.x = x // x is current x gesture location
        self.IndicatorPointPosition.y = m * x + b // y = mx + b
        
        // Find closest point to current indicator position
        // (Used to know which value and label display)
        let distanceToPrevious = distanceBetween(from: CGPoint(x: self.IndicatorPointPosition.x, y: self.IndicatorPointPosition.y), to: previousPoint)
        let distanceToNext = distanceBetween(from: CGPoint(x: self.IndicatorPointPosition.x, y: self.IndicatorPointPosition.y), to: nextPoint)
        
        if distanceToPrevious < distanceToNext {
            index -= 1
        }
        self.showingIndicators = true
        self.indexPosition = index
    }
    
    // Distance between two CGPoint
    private func distanceBetween(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y))
    }
    
    // Haptic feedback played when indicator is dragged on exact value (or limits)
    private func playHapticFeedback() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
}
