//
//  Models.swift
//  Channelized
//
//  Created by Mauro Laurent on 1/9/15.
//  Copyright (c) 2015 Channelized. All rights reserved.
//

import Foundation



class Canal {
    
    var Nombre: String
    var Id: Int?
    var CanalHijos: [Canal] = []
    func AddCanal(cCanal: Canal ) { self.CanalHijos.append(cCanal) }
    var Padre: Int?
    
    init(nombre: String) { self.Nombre = nombre}
    
    var Adultos:Bool = false
    var Privado:Bool = false
    var Descripcion:String?
    var Categoria:Int?
    
    
    
    
    
    
}

class Server {
    
    var Url:String = "http://192.168.0.11:29390/api/"
    
}


class Usuario {
    
    var Id: Int! = 0
    var Username: String! = ""
    var Nombre: String! = ""
    var Apellido: String! = ""
    var Email: String! = ""
    var Password: String! = ""
    
    
    
}

class CategoriaCanal {
    
    var Id: Int? = 0
    var Nombre: String = ""
    var Padre: Int? = 0
}
