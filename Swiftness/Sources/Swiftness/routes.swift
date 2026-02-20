import Fluent
import Vapor
import OpenAPIVapor

func routes(_ app: Application) throws {
    
    let transport = VaporTransport(routesBuilder: app)
    let handler = SwiftnessHandler()
    try handler.registerHandlers(on: transport)
    
    app.get("swagger") { req -> Response in
        guard let path = Bundle.module.path(forResource: "swagger", ofType: "html") else {
            throw Abort(.notFound, reason: "Could not find swagger.html in the bundle.")
        }
        return try await req.fileio.asyncStreamFile(at: path)
    }
    app.get("openapi.yaml") { req -> Response in
            // Use Bundle.module to dynamically find the path to the bundled file.
            guard let path = Bundle.module.path(forResource: "openapi", ofType: "yaml") else {
                throw Abort(.notFound, reason: "Could not find openapi.yaml in the bundle.")
            }
            return try await req.fileio.asyncStreamFile(at: path)
        }
    
//    app.get { req async in
//        "It works!"
//    }
//
//    app.get("hello") { req async -> String in
//        "Hello, world!"
//    }

    try app.register(collection: TodoController())
}
