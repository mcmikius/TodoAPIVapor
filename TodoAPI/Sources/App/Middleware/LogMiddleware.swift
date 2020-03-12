

import Vapor

/// Logs all requests that pass through it.
final class LogMiddleware {
  // Your code here
}

extension TimeInterval {
  /// Converts the time internal to readable milliseconds format, i.e., "3.4ms"
  var readableMilliseconds: String {
    let string = (self * 1000).description
    // include one decimal point after the zero
    let endIndex = string.index(string.index(of: ".")!, offsetBy: 2)
    let trimmed = string[string.startIndex..<endIndex]
    return .init(trimmed) + "ms"
  }
}
