//
//  Event.swift
//  GuardGuys-API
//
//  Created by Patrick Lawler on 2/16/25.
//

import Fluent
import Vapor

final class Event: Model, Content, @unchecked Sendable {
   
    init() {}
    
    init(id: UUID? = nil,
         title: String,
         description: String? = nil,
         location: String? = nil,
         date: Date,
         duration: Int64 = 0,
         assigned_to: UUID? = nil,
         poc_name: String? = nil,
         poc_phone: String? = nil,
         poc_email: String? = nil,
         event_type: String,
         is_archived: Bool
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.location = location
        self.date = date
        self.duration = duration
        self.assigned_to = assigned_to
        self.poc_name = poc_name
        self.poc_phone = poc_phone
        self.poc_email = poc_email
        self.event_type = event_type
        self.is_archived = is_archived
    }
    
    static let schema = "events"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "description")
    var description: String?
    
    @Field(key: "location")
    var location: String?
    
    @Field(key: "date")
    var date: Date
    
    @Field(key: "duration")
    var duration: Int64
    
    @Field(key: "assigned_to")
    var assigned_to: UUID?
    
    @Field(key: "poc_name")
    var poc_name: String?

    @Field(key: "poc_phone")
    var poc_phone: String?
    
    @Field(key: "poc_email")
    var poc_email: String?
   
    @Field(key: "event_type")
    var event_type: String
    
    @Field(key: "is_archived")
    var is_archived: Bool
    
}
