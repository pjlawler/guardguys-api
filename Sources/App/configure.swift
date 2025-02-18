import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    if let databaseURLString = Environment.get("DATABASE_URL"),
       let databaseURL = URL(string: databaseURLString),
       let username = databaseURL.user,
       let password = databaseURL.password {
        let hostname = databaseURL.host ?? "localhost"
        let port = databaseURL.port ?? 5432
        let databaseName = databaseURL.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        var tlsConfig = TLSConfiguration.makeClientConfiguration()
        tlsConfig.certificateVerification = .none
        
        let postgresConfig = SQLPostgresConfiguration(
            hostname: hostname,
            port: port,
            username: username,
            password: password,
            database: databaseName,
            tls: .require(try .init(configuration: tlsConfig)) // Updated TLS handling
        )
        
        app.databases.use(
            .postgres(
                configuration: postgresConfig,
                maxConnectionsPerEventLoop: 10,
                connectionPoolTimeout: .seconds(10),
                encodingContext: .default,
                decodingContext: .default,
                sqlLogLevel: .info
            ), as: .psql)
    }
    else {
        
        let postgresConfig = SQLPostgresConfiguration(
            hostname: "localhost",
            port: 5432,
            username: "vapor_username",
            password: "vapor_password",
            database: "vapor_database",
            tls: .prefer(try .init(configuration: .clientDefault))
        )
        
        app.databases.use(
            .postgres(configuration: postgresConfig), as: .psql)
    }
    
    app.migrations.add(CreateUsers())
    app.migrations.add(CreateEvents())
    app.migrations.add(UpdatingUserModel())
    if app.environment == .development {
        try await app.autoMigrate().get()
    }
    
    // register routes
    try routes(app)
}
