

import FluentSQLite
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // register providers
    try services.register(FluentSQLiteProvider())
    
    /// Register routes to the router
    services.register(Router.self) { c -> EngineRouter in
        let router = EngineRouter.default()
        try routes(router)
        return router
    }
    
    // register custom service types here
    services.register(SecretMiddleware.self)
    services.register(LogMiddleware.self)
    
    /// Setup a simple in-memory SQLite database
    let sqlite = try SQLiteDatabase(storage: .memory)
    services.register(sqlite)
    
    /// Configure SQLite database
    services.register { c -> DatabasesConfig in
        var databases = DatabasesConfig()
        try databases.add(database: c.make(SQLiteDatabase.self), as: .sqlite)
        return databases
    }
    
    /// Configure middleware
    services.register { c -> MiddlewareConfig in
        var middleware = MiddlewareConfig()
        // register your custom middleware here
        middleware.use(LogMiddleware.self)
        middleware.use(ErrorMiddleware.self)
        return middleware
    }
    
    /// Configure migrations
    services.register { c -> MigrationConfig in
        var migrations = MigrationConfig()
        /// Ensure there is a table ready to store the Todos
        migrations.add(model: Todo.self, database: .sqlite)
        /// Ensure SQLiteCache has the tables it will need
        migrations.prepareCache(for: .sqlite)
        return migrations
    }
    
    // preferences
    config.prefer(ConsoleLogger.self, for: Logger.self)
}
