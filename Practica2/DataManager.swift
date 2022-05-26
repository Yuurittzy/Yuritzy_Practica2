//
//  DataManager.swift
//  Practica2
//
//  Created by Yu on 25/05/22.
//

import Foundation


class DataManager: NSObject {
    
    static let instance = DataManager()
    let baseURL = "http://janzelaznog.com/DDAM/iOS/vim/"
    var typeFile : Int = 0
    
    
    override private init() {
        super.init()
        //getInfo()
    }
}
   


