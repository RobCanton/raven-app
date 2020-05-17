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
    var tzOffset:Double = 0
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
        self.backgroundColor = UIColor.clear
        
        self.clearsContextBeforeDrawing = true

        
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        
    }
    
    override func draw(_ rect: CGRect) {
        guard ticks.count >= 2 else { return }
        let aPath = UIBezierPath()
        
        
        
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
            print("t: \(tick.t)")
            print("timespan: \(timespan)")
            print("timeDiff: \(timeDiff)")
            
            let x = CGFloat(timeDiff / timespan) * rect.maxX
            let y = (CGFloat(tick.c)-minValue) / spread * rect.maxY
            print("x: \(x)")
            print("y: \(y)")
            if i == 0 {
                aPath.move(to: CGPoint(x: x, y: y))
            } else {
                aPath.addLine(to: CGPoint(x: x, y: y))
            }
            
            
            print("\(tick.c) | \(tickTime) | \(timeDiff)")
        }
        print("endTime: \(endTime)")
        
        //aPath.addLine(to: CGPoint(x: rect.maxX, y: 0))
        
        let first = ticks.first!
        let last = ticks.last!
        
        if first.c <= last.c {
            Theme.current.positive.set()
        } else {
            Theme.current.negative.set()
        }
        
        
        aPath.lineWidth = 1
        aPath.stroke()
    }
    
    @objc func redraw() {
        self.setNeedsDisplay()
    }
    
    func startLoading() {
        UIView.animate(withDuration: 0.05, animations: {
            self.alpha = 0.0
        })
    }
    
    func displayTicks(_ data:AggregateResponse) {
        let ticks = data.results
        guard ticks.count >= 2 else { return }
        
        startTime = data.start
        endTime = data.end
        tzOffset = data.offset
        
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
        
        
        self.ticks = Array(ticks[startIndex...endIndex])
        
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
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    
 
}
