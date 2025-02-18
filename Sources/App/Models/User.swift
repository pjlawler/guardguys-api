//
//  File.swift
//  GuardGuys-API
//
//  Created by Patrick Lawler on 2/16/25.
//

import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable {
    
    init() {}
    
    init(id: UUID? = nil,
         firstName: String,
         lastName: String,
         phoneNumber: String,
         email: String,
         password: String,
         accountType: String,
         isArchived: Bool)
    {
        self.id = id
        self.first_name = firstName
        self.last_name = lastName
        self.phone_number = phoneNumber
        self.email = email
        self.password = password
        self.account_type = accountType
        self.is_archived = isArchived
    }
    
    static let schema = "users"
    

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "first_name")
    var first_name: String
    
    @Field(key: "last_name")
    var last_name: String
    
    @Field(key: "phone_number")
    var phone_number: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "password")
    var password: String
    
    @Field(key: "account_type")
    var account_type: String
    
    @Field(key: "is_archived")
    var is_archived: Bool
   
}
