private let kMinute = 60
private let kDay = kMinute * 24
private let kWeek = kDay * 7
private let kMonth = kDay * 31
private let kYear = kDay * 365

extension Date {
    /// yyyy-MM-dd HH:mm
    public var toString1: String {
        return DateFormatter.lineYMDHM.string(from: self)
    }
    /// yyyy.MM.dd
    public var toString2: String {
        return DateFormatter.yearForPay.string(from: self)
    }
    /// "yyyy.MM.dd HH:mm"
    public var toString3: String {
        return DateFormatter.yearForPay.string(from: self)
    }
}
extension DateFormatter {

    static public var yearForPay: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter
    }

    static public var dotYMDHM: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        return formatter
    }
    
    static public var lineYMDHM: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }

    static public var dotMDHM: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd HH:mm"
        return formatter
    }

    static public var year: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        return formatter
    }

    static public var _year: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }

    static public var full: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
        return formatter
    }

    static public var currentYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日 HH:mm"
        return formatter
    }

    static public var simpleCurrentYear: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM月dd日"
        return formatter
    }
    
    static public var hourMinute: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
}

extension Calendar {

    func isDateInCurrentYear(_ date: Date) -> Bool {
        let currentYear = self.component(.year, from: Date())
        let dateYear = self.component(.year, from: date)
        return currentYear == dateYear
    }

    func isDateInPreviousYear(_ date: Date) -> Bool {
        let currentYear = self.component(.year, from: Date())
        let dateYear = self.component(.year, from: date)
        return currentYear == (dateYear + 1)
    }

    func isDateInPrevious(nDays: Int) -> (_ date: Date) -> Bool {
        return { date in
            return self.isDate(date, inSameDayAs: Date().addingTimeInterval(-TimeInterval(nDays * 60 * 60 * 24)))
        }
    }
}

extension Date {
    public var stringInIM: String {
        let calendar = Calendar.autoupdatingCurrent

        if calendar.isDateInToday(self) {
            let hour = calendar.component(.hour, from: self)
            let minute = calendar.component(.minute, from: self)
            return String(format: "%.2d:%.2d", hour, minute)
        } else {
            return DateFormatter.currentYear.string(from: self)
        }
    }
}
