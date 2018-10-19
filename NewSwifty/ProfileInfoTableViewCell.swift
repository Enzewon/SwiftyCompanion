//
//  ProfileInfoTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Danil Vdovenko on 1/30/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import UIKit

class ProfileInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var profileLogin: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var wallet: UILabel!
    @IBOutlet weak var correctionPoints: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var levelBar: UIProgressView!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        levelBar.transform = levelBar.transform.scaledBy(x: 1, y: 4)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setInfo(for student: Student) {
        assignbackground()
        if let name = student.name {
            fullName.text = name
            if let secondName = student.surname {
                fullName.text = name + " " + secondName
                fullName.textAlignment = NSTextAlignment.center
            }
        }
        if let login = student.login {
            profileLogin.text = login
        }
        if var path = student.image {
            if path == "https://cdn.intra.42.fr/images/default.png" {
                path = "https://cdn.intra.42.fr/users/default.png"
            }
            if let url = URL(string: path) {
                if let data = try? Data(contentsOf: url) {
                    profileImage.image = UIImage(data: data)
                    makeCircleImage(image: profileImage)
                }
            }
        }
        if let lvl = student.level {
            setLevelBar(for: levelBar, with: lvl)
            level.text = "Level: \(String(format: "%.2f", lvl))%"
        }
        if let mail = student.email {
            email.text = mail
        }
        if let wllt = student.wallet {
            wallet.text = "Wallet: \(String(wllt)) ₳"
        }
        if let corrections = student.correctionPoints {
            correctionPoints.text = "Correction points: \(String(corrections))"
        }
        if let studentLocation = student.location {
            location.text = studentLocation
        }
        if let phone = student.phone {
            phoneNumber.text = phone
        }
    }
    
    func setLevelBar(for levelBar: UIProgressView, with level: Float) {
        let progressLevel = level.truncatingRemainder(dividingBy: 1)
        levelBar.progress = progressLevel
        levelBar.clipsToBounds = true
        levelBar.layer.cornerRadius = levelBar.frame.height / 2
        levelBar.layer.borderWidth = 0.1
        levelBar.layer.borderColor = UIColor.lightGray.cgColor
        levelBar.trackTintColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.0)
        levelBar.progressTintColor = UIColor(red:0.3, green:0.9, blue:1.00, alpha:0.9)
    }
    
    func makeCircleImage(image: UIImageView) {
        image.layer.masksToBounds = false
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
    }
    
    func assignbackground() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "bg")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.insertSubview(backgroundImage, at: 0)
    }

}
