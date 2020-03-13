

import Vapor

/// Rejects requests that do not contain correct secret.
final class SecretMiddleware: Middleware {
    
    let secret: String
    
    init(secret: String) {
        self.secret = secret
    }
    
    func respond(to request: Request, chainingTo next: Responder) throws -> Future<Response> {
        guard request.http.headers.firstValue(name: .xSecret) == secret else {
            throw Abort(.unauthorized, reason: "Incorrect X-Secret header.")
        }
        return try next.respond(to: request)
    }
}

extension SecretMiddleware: ServiceType {
    
    static func makeService(for worker: Container) throws -> SecretMiddleware {
        let secret: String
        switch worker.environment {
        case .development:
            secret = "foo"
        default:
            guard let environmentSecret = Environment.get("SECRET") else {
                let reason = """
No $SECRET set on environment. \
Use "export SECRET=<secret>"
"""
                throw Abort(.internalServerError, reason: reason)
            }
            secret = environmentSecret
        }
        return SecretMiddleware(secret: secret)
    }
}

extension HTTPHeaderName {
    /// Contains a secret key.
    ///
    /// `HTTPHeaderName` wrapper for "X-Secret".
    static var xSecret: HTTPHeaderName {
        return .init("X-Secret")
    }
}
