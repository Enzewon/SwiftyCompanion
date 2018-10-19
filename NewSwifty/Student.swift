//
//  Student.swift
//  SwiftyCompanion
//
//  Created by Danil Vdovenko on 1/28/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import Foundation

struct Student {
    
    var image: String?
    var name: String?
    var surname: String?
    var login: String?
    var email: String?
    var phone: String?
    var wallet: Int?
    var correctionPoints: Int?
    var location: String?
    var level: Float?
    var skills = [Skills]()
    var projects = [Projects]()
    
}

struct Skills {
    var name: String?
    var level: Float?
}

struct Projects {
    var mark: Int?
    var name: String?
    var success: Bool?
}
