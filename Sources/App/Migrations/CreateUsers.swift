//
//  CreateUsers.swift
//  GuardGuys-API
//
//  Created by Patrick Lawler on 2/16/25.
//

import Fluent
import Vapor

struct CreateUsers: Migration {
    func prepare(on database: any FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        return database.schema("users")
            .id()
            .field("first_name", .string, .required)
            .field("last_name", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("account_type", .string, .required)
            .field("is_active", .bool, .required)
            .create()
    }
    
    func revert(on database: any FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
        database.schema("users" ).delete()
    }
    
    
}

