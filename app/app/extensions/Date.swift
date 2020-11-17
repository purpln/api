//
//  Date.swift
//  app
//
//  Created by Sergey Romanenko on 14.11.2020.
//

import Foundation

extension Date {
    func current() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy HH:mm"
        return formatter.string(from: self)
    }
}

func current(_ date:String)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy HH:mm"
    formatter.timeZone = TimeZone(identifier: "UTC")
    guard let converted = formatter.date(from: date) else { return "" }
    formatter.timeZone = .current
    formatter.dateFormat = "dd MMMM yyyy HH:mm"
    return formatter.string(from: converted)
}
