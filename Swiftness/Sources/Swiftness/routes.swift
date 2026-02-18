import Fluent
import Vapor
import OpenAPIVapor

func routes(_ app: Application) throws {
    
    let transport = VaporTransport(routesBuilder: app)
    let handler = SwiftnessHandler()
    try handler.registerHandlers(on: transport)
    
    app.get("swagger") { req -> Response in
        let html = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="utf-8" />
          <title>Swagger UI</title>
          <link rel="stylesheet" href="https://unpkg.com/swagger-ui-dist@5/swagger-ui.css" />
          <script src="https://unpkg.com/swagger-ui-dist@5/swagger-ui-bundle.js"></script>
        </head>
        <body>
          <div id="swagger-ui"></div>
          <script>
            window.onload = () => {
              window.ui = SwaggerUIBundle({
                url: '/openapi.yaml', // Path to the OpenAPI spec file
                dom_id: '#swagger-ui',
              });
            };
          </script>
        </body>
        </html>
        """
        return Response(status: .ok, headers: ["Content-Type": "text/html"], body: .init(string: html))
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
