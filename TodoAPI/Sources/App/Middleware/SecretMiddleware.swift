

import Vapor

/// Rejects requests that do not contain correct secret.
final class SecretMiddleware {
  // Your code here
}

extension HTTPHeaderName {
  /// Contains a secret key.
  ///
  /// `HTTPHeaderName` wrapper for "X-Secret".
  static var xSecret: HTTPHeaderName {
    return .init("X-Secret")
  }
}
