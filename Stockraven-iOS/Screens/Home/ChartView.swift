//
//  ChartView.swift
//  Stockraven
//
//  Created by Robert Canton on 2020-05-15.
//

import Foundation
import UIKit

class ChartView:UIView {
    
    var ticks = [AggregateTick]()
    var startTime:Double = 0
    var endTime:Double = 0
    let tzOffset:Double = 4 * 60 * 60
    var maxValue:CGFloat = 0
    var minValue:CGFloat = 0
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.075)
        
        self.clearsContextBeforeDrawing = true

        
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        
    }
    
    override func draw(_ rect: CGRect) {
        
        let aPath = UIBezierPath()
        aPath.move(to: CGPoint(x: 0, y: 0))
        
        let timespan = endTime - startTime
        let spread = maxValue - minValue
        
        print("startTime: \(startTime)")
        print("max: \(maxValue)")
        print("min: \(minValue)")
        print("spread: \(spread)")
        
        for i in 0..<ticks.count {
            let tick = ticks[i]
            let tickTime = tick.t/1000-tzOffset
            let timeDiff = tickTime - startTime
            
            let x = CGFloat(timeDiff / timespan) * rect.maxX
            let y = (CGFloat(tick.c)-minValue) / spread * rect.maxY
            
            aPath.addLine(to: CGPoint(x: x, y: y))
            
            print("\(tick.c) | \(tickTime) | \(timeDiff)")
        }
        print("endTime: \(endTime)")
        
        //aPath.addLine(to: CGPoint(x: rect.maxX, y: 0))
        
        Theme.current.positive.set()
        
        aPath.lineWidth = 1
        aPath.stroke()
    }
    
    @objc func redraw() {
        self.setNeedsDisplay()
    }
    
    func displayTicks(_ ticks:[AggregateTick]) {
        guard ticks.count >= 2 else { return }
        
        startTime = "2020-05-15 09:30:00".toDate()!.timeIntervalSince1970-tzOffset
        endTime = "2020-05-15 16:00:00".toDate()!.timeIntervalSince1970-tzOffset
        
        let startTick = AggregateTick(v: 0,
                                      vw: 0,
                                      o: 0,
                                      c: 0,
                                      h: 0,
                                      l: 0,
                                      t: (startTime + tzOffset)*1000)
        let startIndex = binarySearch(array: ticks, value: startTick, greater: true) ?? 0
        
        let endTick = AggregateTick(v: 0,
                                    vw: 0,
                                    o: 0,
                                    c: 0,
                                    h: 0,
                                    l: 0,
                                    t: (endTime + tzOffset)*1000)
        let endIndex = binarySearch(array: ticks, value: endTick, greater: false) ?? ticks.count - 1
        print("startI")
        
        self.ticks = Array(ticks[startIndex...endIndex])/*filter { t in
            return t.t >= startTime && t.t <= endTime
        }*/
        
        var _maxValue:Double = 0
        var _minValue:Double = Double.greatestFiniteMagnitude
        for tick in self.ticks {
            if tick.c > _maxValue {
                _maxValue = tick.c
            }
            if tick.c < _minValue {
                _minValue = tick.c
            }
        }
        
        self.maxValue = CGFloat(_maxValue)
        self.minValue = CGFloat(_minValue)
        
        redraw()
    }
    
    
 
}
