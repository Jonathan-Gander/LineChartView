//
//  LinePath.swift
//  ChartLineView Package
//
//  Created by Jonathan Gander
//

import SwiftUI

public struct LinePath: Shape {
    public var data: [Double]
    public var (width, height): (CGFloat, CGFloat)
    
    public var dotsSize: CGFloat
    
    public var lineWidth: CGFloat
    
    @Binding var pathPoints: [CGPoint]
    
    var pathTimestamps: [Date]?
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        var pathPoints = [CGPoint]()
        
        // Case of x values are timestamps
        let isXTimestamps = pathTimestamps != nil
        var firstTimestamp: TimeInterval? = nil
        var widthForASecond: Double? = nil
        if isXTimestamps {
            firstTimestamp = pathTimestamps!.first!.timeIntervalSince1970
            let lastTimestamp  = pathTimestamps!.last!.timeIntervalSince1970
            
            let totalSeconds = lastTimestamp - firstTimestamp!
            widthForASecond = Double(width) / totalSeconds
        }
        
        // When chart has only one value (only display a dot in center bottom)
        if data.count == 1 {
            let x: Double = width / 2.0
            let y: Double = 0
            
            path.move(to: CGPoint(x: x, y: y))
            
            var pointSize = Int(lineWidth)
            if dotsSize > 0 {
                pointSize = Int(dotsSize)
            }
            for i in 1...pointSize {
                let j = CGFloat(i)
                path.addEllipse(in: CGRect(x: x-(j/2), y: y-(j/2), width: j, height: j))
            }
            
            // Append current point to an array. Later will be used for Drag Gesture
            pathPoints.append(path.currentPoint ?? CGPoint(x: 0, y: 0))
        }
        // When chart has more than one value
        else {
            
            let initialPoint = data[0] * Double(height)
            let widthBetweenDataPoints = Double(width) / Double(data.count - 1)  // Remove first point
            var x: Double = isXTimestamps ? 0 : -widthBetweenDataPoints
            
            path.move(to: CGPoint(x: 0, y: initialPoint))
            var i = 0
            for y in data {
                
                // Calculate x position
                if isXTimestamps && firstTimestamp != nil && widthForASecond != nil {
                    // When x values are timestamps, need to calculate x value depending on timestamp (= space between each)
                    let currentSecondsFromFirst = pathTimestamps![i].timeIntervalSince1970 - firstTimestamp!
                    x = currentSecondsFromFirst * widthForASecond!
                    i+=1
                }
                else {
                    // 'Classical' case (all x values have equal spaces between each)
                    x += widthBetweenDataPoints
                }
                
                // Calculate y position
                let y = y * Double(height)
                
                path.addLine(to: CGPoint(x: x, y: y))
                
                // Note: As it's not possible to add stroke() + fill() to LinePath(), I had to draw
                // dots as a set of Ellipse from size of 1 to dotsSize.
                if dotsSize > 0 {
                    for i in 1...Int(dotsSize) {
                        let j = CGFloat(i)
                        path.addEllipse(in: CGRect(x: x-(j/2), y: y-(j/2), width: j, height: j))
                    }
                    
                    path.move(to: CGPoint(x: x, y: y))
                }
                
                // Append current point to an array. Later will be used for Drag Gesture
                pathPoints.append(path.currentPoint ?? CGPoint(x: 0, y: 0))
            }
        }
        
        DispatchQueue.main.async {
            self.pathPoints = pathPoints
        }
        
        return path
    }
}

