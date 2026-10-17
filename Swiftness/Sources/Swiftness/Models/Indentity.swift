//
//  Indentity.swift
//  Swiftness
//
//  Created by Junsu Jeon on 2/23/26.


import Fluent
import struct Foundation.UUID

final class ExternalIdentity: Model, @unchecked Sendable {
    static let schema: String = "identities"
    
    @ID(key: .id)
    var id: UUID?
    
    
    init() {}
    
}
