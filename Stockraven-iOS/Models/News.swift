//
//  News.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-05.
//

import Foundation

struct News:Codable {
    let datetime:Double
    let headline:String
    let source:String
    let url:String
    let summary:String
    let image:String
    let lang:String
    let hasPaywall:Bool
    
    var date:Date? {
        return Date(timeIntervalSinceReferenceDate: datetime/1000)
    }
}
