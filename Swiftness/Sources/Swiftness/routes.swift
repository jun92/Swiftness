import Fluent
import Vapor
import OpenAPIVapor

func routes(_ app: Application) throws {
    
    let transport = VaporTransport(routesBuilder: app)
    let handler = SwiftnessHandler()
    try handler.registerHandlers(on: transport)
    
    
    print("현재 작업 디렉토리: \(app.directory.workingDirectory)")
    
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
                url: '/openapi.yaml', // yaml 경로
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
            // Bundle.module을 사용하여 번들 내 파일 경로를 동적으로 찾습니다.
            guard let path = Bundle.module.path(forResource: "openapi", ofType: "yaml") else {
                throw Abort(.notFound, reason: "번들에서 openapi.yaml을 찾을 수 없습니다.")
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
