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
                configuration: postgresConfig, // Ensure this is passed properly
                maxConnectionsPerEventLoop: 10,
                connectionPoolTimeout: .seconds(10),
                encodingContext: .default,
                decodingContext: .default,
                sqlLogLevel: .info
            ),
            as: .psql
        )

    }
    else {
        app.databases.use(DatabaseConfigurationFactory.postgres(configuration: .init(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database",
            tls: .prefer(try .init(configuration: .clientDefault)))
        ), as: .psql)
        
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
