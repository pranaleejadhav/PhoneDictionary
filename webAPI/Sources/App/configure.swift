import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    /// Register providers first
    
    try services.register(FluentPostgreSQLProvider())
    /// Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    
    
    /// Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    /// middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    let postgresqlConfig = PostgreSQLDatabaseConfig(
        hostname: "127.0.0.1",
        port: 5432,
        username: "pranalee",
        database: "contacts",
        password: nil
    )
   // let postgres = PostgreSQLDatabase(config: postgresqlConfig)
    
    var databases = DatabasesConfig()
    let databaseConfig:PostgreSQLDatabaseConfig
    if let url = Environment.get("DATABASE_URL"), let c = PostgreSQLDatabaseConfig(url:url) {
        databaseConfig = c
    } else {
        databaseConfig = postgresqlConfig
    }
    
    let database = PostgreSQLDatabase(config: databaseConfig)
    databases.add(database: database, as: .psql)
    services.register(databases)
    
    /// Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    services.register(migrations)
    
}
