//
//  Request.swift
//  SwiftyCompanion
//
//  Created by Danil Vdovenko on 1/28/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import Foundation
import UIKit

class Request {
    
    var key: String
    var secret: String
    var token: String?
    
    init (key: String, secret: String) {
        self.key = key
        self.secret = secret
    }
    
    public func basicRequest() {
        let bearer = ((key + ":" + secret).data(using: String.Encoding.utf8))!.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
        let url = URL(string: "https://api.intra.42.fr/oauth/token")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        request.setValue("Basic " + bearer, forHTTPHeaderField: "Authorization")
        request.httpBody = "grant_type=client_credentials&client_id=\(key)&client_secret=\(secret)".data(using: String.Encoding.utf8)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    self.token = (dic["access_token"] as? String)!
                    if let token = self.token {
                        print("Access token: \(token)")
                    }
                }
                catch (let error) {
                    print(error)
                }
            }
        }
        task.resume()
    }
    
    public func getUser(token access_token: String, about user: String, addUser: @escaping ([String: Any]?, Error?) -> Void) {
        let url = URL(string: "https://api.intra.42.fr/v2/users/\(user.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)?access_token=\(access_token)")
        let request = URLRequest(url: url! as URL)
        let task = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    if let dic = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        addUser(dic, nil)
                    }
                }
                catch (let error) {
                    print(error)
                }
            }
            addUser(nil, error)
        }
        task.resume()
    }

    public func setStudent(response: [String: Any]) -> Student {
        
        var foundStudent = Student()

        if let img = response["image_url"] as? String {
            foundStudent.image = img
        }
        if let name = response["first_name"] as? String {
            foundStudent.name = name
        }
        if let surname = response["last_name"] as? String {
            foundStudent.surname = surname
        }
        if let login = response["login"] as? String {
            foundStudent.login = login
        }
        if let email = response["email"] as? String {
            foundStudent.email = email
        }
        if let phone = response["phone"] as? String {
            foundStudent.phone = phone
        } else {
            foundStudent.phone = "No phone number"
        }
        if let wallet = response["wallet"] as? Int {
            foundStudent.wallet = wallet
        }
        if let correctionPoints = response["correction_point"] as? Int {
            foundStudent.correctionPoints = correctionPoints
        }
        if let location = response["location"] as? String {
            foundStudent.location = "Available " + location
        } else {
            foundStudent.location = "Unavailable"
        }
        if let dictionary = response["cursus_users"] as? [NSDictionary] {
            var cursus = NSDictionary()
            for course in dictionary {
                if course.value(forKey: "cursus_id") as? Int == 1 {
                    cursus = course
                }
            }
            if let level = cursus["level"] as? Float {
                foundStudent.level = level
            } else {
                foundStudent.level = 0.0
            }
            if let dictionary = cursus["skills"] as? [NSDictionary] {
                for skill in dictionary {
                    foundStudent.skills.append(Skills(name: skill.value(forKey: "name") as? String, level: skill.value(forKey: "level") as? Float))
                }
            }
        }
        if let dictionary = response["projects_users"] as? [NSDictionary] {
            for projects in dictionary {
                if let id = projects.value(forKey: "cursus_ids") as? [Int] {
                    if id[0] == 1 {
                        if let success = projects["validated?"] as? Bool,
                            let finalMark = projects["final_mark"] as?  Int,
                            let projectInfo = projects["project"] as? [String: Any?] {
                            foundStudent.projects.append(Projects(mark: finalMark, name: projectInfo["slug"] as? String, success: success))
                        }
                    }
                }
            }
        }
        return foundStudent
    }

}
