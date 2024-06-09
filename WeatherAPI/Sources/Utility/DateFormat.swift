//
//  DateFormat.swift
//  WeatherAPI
//
//  Created by gnksbm on 6/9/24.
//

import Foundation

enum DateFormat: String {
    private static var cachedStorage = [DateFormat: DateFormatter]()
    
    case weatherHeader = "MM월 dd일 hh시 mm분"
    case meridiem = "a"
    
    var formatter: DateFormatter {
        if let formatter = Self.cachedStorage[self] {
            return formatter
        } else {
            let newFormatter = DateFormatter()
            newFormatter.dateFormat = self.rawValue
            newFormatter.locale = Locale(identifier: "ko_KR")
            Self.cachedStorage[self] = newFormatter
            return newFormatter
        }
    }
}

extension String {
    func formatted(dateFormat: DateFormat) -> Date? {
        dateFormat.formatter.date(from: self)
    }
}

extension Date {
    func formatted(dateFormat: DateFormat) -> String {
        dateFormat.formatter.string(from: self)
    }
    
    func getMeridiem() -> Meridiem {
        if DateFormat.meridiem.formatter.string(from: self)
            == Calendar.current.amSymbol {
            return .ante
        } else {
            return .post
        }
    }
    
    enum Meridiem {
        case ante, post
    }
}

