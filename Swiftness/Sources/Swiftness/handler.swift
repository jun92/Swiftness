import OpenAPIRuntime
import OpenAPIVapor
import Vapor

struct SwiftnessHandler: APIProtocol {
    
    func healthCheck(_ input: Operations.healthCheck.Input) async throws -> Operations.healthCheck.Output {
        return .ok(.init())
    }
}
