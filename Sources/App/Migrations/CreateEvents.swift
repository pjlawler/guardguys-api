//
//  CreateEvents.swift
//  GuardGuys-API
//
//  Created by Patrick Lawler on 2/16/25.
//


import Fluent
import Vapor

struct CreateEvents: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Event.schema)
            .id() // Creates an "id" column of type UUID.
            .field("title", .string, .required)
            .field("description", .string)         // Optional string.
            .field("location", .string)              // Optional string.
            .field("date", .datetime, .required)
            .field("duration", .int64, .required)
            .field("assigned_to", .uuid)             // Optional UUID.
            .field("poc_name", .string)              // Optional string.
            .field("poc_phone", .string)             // Optional string.
            .field("poc_email", .string)             // Optional string.
            .field("event_type", .string, .required)
            .field("is_archived", .bool, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Event.schema).delete()
    }
}
