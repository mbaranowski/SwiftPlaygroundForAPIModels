import Foundation

/*:
 I perfer to use optional chaining instead of
 
 `if let url = URL(string: someURL) { .. } else { .. }` or variants
 
 so I make convenience optional computed properties for each conversion
 */
public extension String {
    var toURL: URL? {
        return URL(string: self)
    }
}

public extension String {
    func toDate(with formatter: DateFormatter) -> Date? {
        return formatter.date(from: self)
    }
    
    var toIso8601Date: Date? {
        return Formatter.iso8601.date(from: self)
    }
}

public extension Formatter {
    static let short = DateFormatter(dateStyle: .short)
    static let iso8601 = ISO8601DateFormatter(options: [.withInternetDateTime, .withFractionalSeconds])
}

public extension DateFormatter {
    convenience init(dateStyle: DateFormatter.Style) {
        self.init()
        self.dateStyle = dateStyle
    }
}

public extension ISO8601DateFormatter {
    convenience init(options: ISO8601DateFormatter.Options) {
        self.init()
        self.formatOptions = options
    }
}

public extension JSONEncoder {
    convenience init(format: OutputFormatting,
                     dateFormat: DateEncodingStrategy = .deferredToDate,
                     dataFormat: DataEncodingStrategy = .deferredToData,
                     keyFormat: KeyEncodingStrategy = .useDefaultKeys) {
        self.init()
        self.outputFormatting = format
        self.dateEncodingStrategy = dateFormat
        self.dataEncodingStrategy = dataFormat
        self.keyEncodingStrategy = keyFormat
    }
}
