//
//  RavenAPI+Aggregates.swift
//  Stockraven
//
//  Created by Robert Canton on 2020-05-15.
//

import Foundation

extension RavenAPI {
    
    enum Timespan:String {
        case minute = "minute"
        case hour = "hour"
        case day = "day"
        case week = "week"
        case month = "month"
        case quarter = "quarter"
        case year = "year"
    }
    
    static func getAggregate(for symbol:String, multiplier:Int, timespan: Timespan, from: Date, to: Date, completion: @escaping(_ ticks:[AggregateTick])->()) {
        let url = "\(getURL(for: .refStockAggregates))\(symbol)/range/\(multiplier)/\(timespan.rawValue)/2020-05-15/2020-05-15"
        var ticks = [AggregateTick]()
        authenticatedRequest(.get, url: url) { data, response, error in
            
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(AggregateResponse.self, from: data)
                    ticks = response.results
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }

            DispatchQueue.main.async {
                completion(ticks)
            }
        }
    }
}
