//
//  BarChartFormatter.swift
//  skillCounter
//
//  Created by 田中江樹 on 2017-03-14.
//  Copyright © 2017 Koki. All rights reserved.
//

import UIKit
import Foundation
import Charts

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter{
    
    //var dayweeks: [String]! = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var dayweeks: [String]!
    
    init(dayweeks: [String]) {
        self.dayweeks = dayweeks
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let val = Int(value)
        
        if val >= 0 && val < dayweeks.count {
            return dayweeks[Int(val)]
        }
        
        return ""
    }
}

