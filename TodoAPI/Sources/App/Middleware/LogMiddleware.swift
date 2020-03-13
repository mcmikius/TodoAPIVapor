

import Vapor

/// Logs all requests that pass through it.
final class LogMiddleware: Middleware {
    
    let logger: Logger
    
    init(logger: Logger) {
        self.logger = logger
    }
    
    func respond(to req: Request, chainingTo next: Responder) throws -> Future<Response> {
        logger.info(req.description)
        return try next.respond(to: req)
    }
}

extension LogMiddleware: ServiceType {
    static func makeService(for container: Container) throws -> LogMiddleware {
        return try .init(logger: container.make())
    }
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
