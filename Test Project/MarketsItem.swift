//
//  MarketsItem.swift
//  Test Project
//
//  Created by Alen Akif on 17.11.22..
//

import Foundation
import UIKit

class MarketsItem{
    let id: String
    
    var name: String
    let ticketSymbol:String
    let isin:String
    let currency:String
    let stockExchangeName:String
    let decorativeName:String
    var last: Double
    var high: Double
    var low: Double
    var bid: Double
    var ask: Double
    var volume: Double
    var dataTime:Date
    var change: Double
    var changePercent:Double
    var color: Int
  
    init(id: String, name: String, ticketSymbol: String, isin: String, currency: String, stockExchangeName: String, decorativeName: String, last: Double, high: Double, low: Double, bid: Double, ask: Double, volume: Double, dataTime: Date, change: Double, changePercent: Double) {
        self.id = id
        self.name = name
        self.ticketSymbol = ticketSymbol
        self.isin = isin
        self.currency = currency
        self.stockExchangeName = stockExchangeName
        self.decorativeName = decorativeName
        self.last = last
        self.high = high
        self.low = low
        self.bid = bid
        self.ask = ask
        self.volume = volume
        self.dataTime = dataTime
        self.change = change
        self.changePercent = changePercent
        self.color = 2
        
    }
    
    
}
