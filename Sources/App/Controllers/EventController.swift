//
//  EventController.swift
//  GuardGuys-API
//
//  Created by Patrick Lawler on 2/16/25.
//

import Fluent
import Vapor

struct EventController: RouteCollection, Sendable {
    
    func boot(routes: any Vapor.RoutesBuilder) throws {
        
        let events = routes.grouped("events")
        
        events.get(use: index)
        events.post(use: create)
        events.put(use: update)
        events.group(":id") { event in
            event.delete(use: delete)
        }
    }
    
    @Sendable
    func index(req: Request) throws -> EventLoopFuture<[Event]> {
        return Event.query(on: req.db).all()
    }
    
    @Sendable
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let event = try req.content.decode(Event.self)
        return event.save(on: req.db).transform(to: .ok)
    }
    
    @Sendable
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let event = try req.content.decode(Event.self)
        return Event.find(event.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.id = event.id
                $0.title = event.title
                $0.description = event.description
                $0.location = event.location
                $0.date = event.date
                $0.duration = event.duration
                $0.assigned_to = event.assigned_to
                $0.poc_name = event.poc_name
                $0.poc_phone = event.poc_phone
                $0.poc_email = event.poc_email
                $0.event_type = event.event_type
                $0.is_archived = event.is_archived
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    @Sendable
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Event.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
    
}
