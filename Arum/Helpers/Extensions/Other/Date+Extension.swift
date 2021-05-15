//
//  Date+Extension.swift
//  iOS Structure MVC
//
//  Created by vinhdd on 10/9/18.
//  Copyright © 2018 vinhdd. All rights reserved.
//

import UIKit
import Foundation

// MARK: - General
extension Date {
    // MARK: - Variables
    static let currentCalendar = Calendar(identifier: .gregorian)
    static let currentTimeZone = TimeZone.ReferenceType.local
    
    var currentAge: Int? {
        let ageComponents = Date.currentCalendar.dateComponents([.year], from: self, to: Date())
        return ageComponents.year
    }
    
    var yesterday: Date? {
        return Date.currentCalendar.date(byAdding: .day, value: -1, to: self)
    }
    var tomorrow: Date? {
        return Date.currentCalendar.date(byAdding: .day, value: 1, to: self)
    }
    var weekday: Int {
        return Date.currentCalendar.component(.weekday, from: self)
    }
    
    var day: Int? {
        return components().day
    }
    
    var month: Int? {
        return components().month
    }
    
    var year: Int? {
        return components().year
    }
    
    var hour: Int? {
        return components().hour
    }
    
    var minute: Int? {
        return components().minute
    }
    
    var second: Int? {
        return components().second
    }
    
    var weekDayTextInEnglish: String? {
        let weekday = self.weekday
        switch weekday {
        case 2: return "weekday_monday_en".localized
        case 3: return "weekday_tuesday_en".localized
        case 4: return "weekday_wednesday_en".localized
        case 5: return "weekday_thursday_en".localized
        case 6: return "weekday_friday_en".localized
        case 7: return "weekday_saturday_en".localized
        case 1: return "weekday_sunday_en".localized
        default: return nil
        }
    }
    
    var weekDayTextInJapanese: String? {
        let weekday = self.weekday
        switch weekday {
        case 2: return "weekday_monday_jp".localized
        case 3: return "weekday_tuesday_jp".localized
        case 4: return "weekday_wednesday_jp".localized
        case 5: return "weekday_thursday_jp".localized
        case 6: return "weekday_friday_jp".localized
        case 7: return "weekday_saturday_jp".localized
        case 1: return "weekday_sunday_jp".localized
        default: return nil
        }
    }
    
    // MARK: - Init
    init(year: Int, month: Int, day: Int, calendar: Calendar = Date.currentCalendar) {
        var dc = DateComponents()
        dc.year = year
        dc.month = month
        dc.day = day
        if let date = calendar.date(from: dc) {
            self.init(timeInterval: 0, since: date)
        } else {
            fatalError("Date component values were invalid.")
        }
    }
    
    init(hour: Int, minute: Int, second: Int, calendar: Calendar = Date.currentCalendar) {
        var dc = DateComponents()
        dc.hour = hour
        dc.minute = minute
        dc.second = second
        if let date = calendar.date(from: dc) {
            self.init(timeInterval: 0, since: date)
        } else {
            fatalError("Date component values were invalid.")
        }
    }
    
    init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int, calendar: Calendar = Date.currentCalendar) {
        var dc = DateComponents()
        dc.year = year
        dc.month = month
        dc.day = day
        dc.hour = hour
        dc.minute = minute
        dc.second = second
        if let date = calendar.date(from: dc) {
            self.init(timeInterval: 0, since: date)
        } else {
            fatalError("Date component values were invalid.")
        }
    }
    
    // MARK: - Static functions
    static func componentsBy(string: String, format: String, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> DateComponents? {
        if let date = dateBy(string: string, format: format, calendar: calendar, timeZone: timeZone) {
            return date.components(calendar: calendar, timeZone: timeZone)
        }
        return nil
    }
    
    static func dateBy(string: String, format: String, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = timeZone
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
    
    static func dateAt(timeInterval: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> DateComponents {
        let date = Date(timeIntervalSince1970: TimeInterval(timeInterval))
        return date.components(calendar: calendar, timeZone: timeZone)
    }
    
    static func startOfMonth(date: Date, calendar: Calendar = Date.currentCalendar) -> Date? {
        return calendar.date(from: calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: date)))
    }
    
    static func endOfMonth(date: Date, calendar: Calendar = Date.currentCalendar) -> Date? {
        if let startOfMonth = startOfMonth(date: date, calendar: calendar) {
            return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)
        }
        return nil
    }
    
    static func hourMinuteSecondFrom(secondValue: Int) -> (hour: Int, minute: Int, second: Int) {
        return (secondValue / 3600, (secondValue % 3600) / 60, (secondValue % 3600) % 60)
    }
    
    static func daysBetween(date start: Date, andDate end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
    
    // MARK: - Local functions
    func isToday(calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDateInToday(self)
    }
    
    func isYesterday(calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDateInYesterday(self)
    }
    
    func isTomorrow(calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDateInTomorrow(self)
    }
    
    func isWeekend(calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDateInWeekend(self)
    }
    
    func isSamedayWith(date: Date, calendar: Calendar = Date.currentCalendar) -> Bool {
        return calendar.isDate(self, inSameDayAs: date)
    }
    
    func components(calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> DateComponents {
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: timeZone,
                                            era: calendar.component(.era, from: self),
                                            year: calendar.component(.year, from: self),
                                            month: calendar.component(.month, from: self),
                                            day: calendar.component(.day, from: self),
                                            hour: calendar.component(.hour, from: self),
                                            minute: calendar.component(.minute, from: self),
                                            second: calendar.component(.second, from: self),
                                            nanosecond: calendar.component(.nanosecond, from: self),
                                            weekday: calendar.component(.weekday, from: self),
                                            weekdayOrdinal: calendar.component(.weekdayOrdinal, from: self),
                                            quarter: calendar.component(.quarter, from: self),
                                            weekOfMonth: calendar.component(.weekOfMonth, from: self),
                                            weekOfYear: calendar.component(.weekOfYear, from: self),
                                            yearForWeekOfYear: calendar.component(.yearForWeekOfYear, from: self))
        return dateComponents
    }
    
    func add(day: Int? = nil, month: Int? = nil, year: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, calendar: Calendar = Date.currentCalendar) -> Date? {
        var dateComponent = DateComponents()
        if let year = year { dateComponent.year = year }
        if let month = month { dateComponent.month = month }
        if let day = day { dateComponent.day = day }
        if let hour = hour { dateComponent.hour = hour }
        if let minute = minute { dateComponent.minute = minute }
        if let second = second { dateComponent.second = second }
        return calendar.date(byAdding: dateComponent, to: self)
    }
    
    func stringBy(format: String, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
    
    func years(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.year], from: date, to: self).year ?? 0
    }
    
    func months(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.month], from: date, to: self).month ?? 0
    }
    
    func weeks(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    
    func days(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    func hours(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    
    func minutes(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func seconds(from date: Date, calendar: Calendar = Date.currentCalendar) -> Int {
        return calendar.dateComponents([.second], from: date, to: self).second ?? 0
    }
    
    func set(year: Int, month: Int, day: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        return self.set(year: year, calendar: calendar, timeZone: timeZone)?
            .set(month: month, calendar: calendar, timeZone: timeZone)?
            .set(day: day, calendar: calendar, timeZone: timeZone)
    }
    
    func set(hour: Int, minute: Int, second: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        return self.set(hour: hour, calendar: calendar, timeZone: timeZone)?
            .set(minute: minute, calendar: calendar, timeZone: timeZone)?
            .set(second: second, calendar: calendar, timeZone: timeZone)
    }
    
    func set(year: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.components(calendar: calendar, timeZone: timeZone)
        components.year = year
        return calendar.date(from: components)
    }
    
    func set(month: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.components(calendar: calendar, timeZone: timeZone)
        components.month = month
        return calendar.date(from: components)
    }
    
    func set(day: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.components(calendar: calendar, timeZone: timeZone)
        components.day = day
        return calendar.date(from: components)
    }
    
    func set(hour: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.components(calendar: calendar, timeZone: timeZone)
        components.hour = hour
        return calendar.date(from: components)
    }
    
    func set(minute: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.components(calendar: calendar, timeZone: timeZone)
        components.minute = minute
        return calendar.date(from: components)
    }
    
    func set(second: Int, calendar: Calendar = Date.currentCalendar, timeZone: TimeZone = Date.currentTimeZone) -> Date? {
        var components = self.components(calendar: calendar, timeZone: timeZone)
        components.second = second
        return calendar.date(from: components)
    }
}

