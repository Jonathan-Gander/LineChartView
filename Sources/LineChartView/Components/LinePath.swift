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
    
    @Binding var pathPoints: [CGPoint]
    
    var animatableData: [Double] {
        get { data }
        set { data = newValue }
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        var pathPoints = [CGPoint]()
        
        let widthBetweenDataPoints = Double(width) / Double(data.count - 1)  // Remove first point
        let initialPoint = data[0] * Double(height)
        var x: Double = -widthBetweenDataPoints
        
        path.move(to: CGPoint(x: 0, y: initialPoint))
        for y in data {
            x += widthBetweenDataPoints
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
        
        DispatchQueue.main.async {
            self.pathPoints = pathPoints
        }
        
        return path
    }
}

