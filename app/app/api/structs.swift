//
//  structs.swift
//  app
//
//  Created by Sergey Romanenko on 12.11.2020.
//

import Foundation

struct Info:Codable{
    var api:String
    var version:String
    var description:String
    var error:Bool
    var data:String
    var seed:String
}

struct actionError:Codable{
    var info:Info
}

struct actionString:Codable{
    var values:String
    var info:Info
}

struct actionUserByToken:Codable{
    var values:values
    var info:Info
    
    struct values:Codable{
        var id:Int
        var username:String
        var password:String
        var email:String
        var name:String
        var rank:String
        var token:String
        var color:Int
        var date:Date
        var last:Date
        var photo:String
    }
}

struct actionUserByUsername:Codable{
    var values:values
    var info:Info
    
    struct values:Codable{
        var id:Int
        var username:String
        var email:String
        var name:String
        var rank:String
        var color:Int
        var date:Date
        var last:Date
        var photo:String
    }
}

struct actionListUsers:Codable{
    var values:[values]
    var info:Info
    
    struct values:Codable{
        var id:String
        var username:String
        var email:String
        var name:String
        var rank:String
        var color:String
        var date:Date
        var last:Date
        var photo:String
    }
}

struct actionColors:Codable{
    var values:[values]
    var info:Info
    
    struct values:Codable{
        var id:String
        var name:String
        var hex:String
    }
}
