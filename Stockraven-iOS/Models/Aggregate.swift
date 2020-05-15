//
//  AggregateTick.swift
//  Stockraven
//
//  Created by Robert Canton on 2020-05-15.
//

import Foundation

struct AggregateResponse: Codable {
    let ticker: String
    let results: [AggregateTick]
}

struct AggregateTick:Codable, Comparable, Equatable {
    
    let v: Double
    let vw: Double
    let o: Double
    let c: Double
    let h: Double
    let l: Double
    let t: Double
    
    static func < (lhs: AggregateTick, rhs: AggregateTick) -> Bool {
        return lhs.t < rhs.t
    }
}
