//
//  UserController.swift
//  GuardGuys-API
//
//  Created by Patrick Lawler on 2/16/25.
//

import Fluent
import Vapor

struct UserController: RouteCollection, Sendable {
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: index)
        users.post(use: create)
        users.put(use: update)
        users.group(":id") { user in
            user.delete(use: delete)
        }
    }
    
    @Sendable
    func index(req: Request) throws -> EventLoopFuture<[User]> {
        return User.query(on: req.db).all()
    }
    
    @Sendable
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let user = try req.content.decode(User.self)
        return user.save(on: req.db).transform(to: .ok)
    }
    
    @Sendable
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let user = try req.content.decode(User.self)
        return User.find(user.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.id = user.id
                $0.first_name = user.first_name
                $0.last_name = user.last_name
                $0.phone_number = user.phone_number
                $0.email = user.email
                $0.password = user.password
                $0.account_type = user.account_type
                $0.is_archived = user.is_archived
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    @Sendable
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        User.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}
