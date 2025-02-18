//
//  UpdatingUserModel.swift
//  GuardGuys-API
//
//  Created by Patrick Lawler on 2/16/25.
//

import Fluent
import Vapor
import SQLKit

struct UpdatingUserModel: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
           // 1. Add new columns: phone_number and is_archived.
           return database.schema("users")
               .field("phone_number", .string, .required, .sql(.default("")))
               .field("is_archived", .bool, .required, .sql(.default(false)))
               .update()
               .flatMap {
                   // 2. Copy data from is_active to is_archived (inverting the value)
                   guard let sqlDatabase = database as? SQLDatabase else {
                       return database.eventLoop.makeSucceededFuture(())
                   }
                   return sqlDatabase.raw("UPDATE users SET is_archived = NOT is_active").run()
               }
               .flatMap {
                   // 3. Remove the old is_active column.
                   database.schema("users")
                       .deleteField("is_active")
                       .update()
               }
       }
       
       func revert(on database: Database) -> EventLoopFuture<Void> {
           // Revert: Add is_active back, copy data from is_archived, and remove phone_number and is_archived.
           return database.schema("users")
               .field("is_active", .bool, .required, .sql(.default(true)))
               .update()
               .flatMap {
                   guard let sqlDatabase = database as? SQLDatabase else {
                       return database.eventLoop.makeSucceededFuture(())
                   }
                   return sqlDatabase.raw("UPDATE users SET is_active = NOT is_archived").run()
               }
               .flatMap {
                   database.schema("users")
                       .deleteField("is_archived")
                       .deleteField("phone_number")
                       .update()
               }
       }
}
