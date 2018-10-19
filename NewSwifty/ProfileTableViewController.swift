//
//  ProfileTableViewController.swift
//  SwiftyCompanion
//
//  Created by Danil Vdovenko on 1/29/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    var student: Student?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        if section == 1 {
            if let skillsNumber = student?.skills.count {
                return skillsNumber
            }
        }
        if section == 2 {
            if let projectsNumber = student?.projects.count {
                return projectsNumber
            }
        }
        return 0
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileInfo", for: indexPath) as? ProfileInfoTableViewCell {
                if let student = student {
                    cell.setInfo(for: student)
                    tableView.rowHeight = UITableViewAutomaticDimension
                    tableView.estimatedRowHeight = 160
                }
                return cell
            }
        }
        if indexPath.section == 1 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SkillsInfo", for: indexPath) as? SkillsTableViewCell {
                if let skill = student?.skills[indexPath.row] {
                    cell.setSkills(with: skill)
                }
                return cell
            }
        }
        if indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectsInfo", for: indexPath) as? ProjectsTableViewCell {
                if let project = student?.projects[indexPath.row] {
                    cell.setProjects(with: project)
                }
                return cell
            }
        }
        return UITableViewCell()
    }

    override    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return addHeader(with: #imageLiteral(resourceName: "profile"), and: "User Info")
        }
        if section == 1 {
            return addHeader(with: #imageLiteral(resourceName: "skills"), and: "User Skills")
        }
        if section == 2 {
            return addHeader(with: #imageLiteral(resourceName: "projects"), and: "User Projects")
        }
        return UIView()
    }
    
    func addHeader(with image: UIImage, and text: String) -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.7, green:0.8, blue:0.8, alpha:1.0)
        
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 5, y: 5, width: 35, height: 35)
        view.addSubview(imageView)
        
        let label = UILabel()
        label.text = text
        label.frame = CGRect(x: 45, y: 5, width: 200, height: 35)
        view.addSubview(label)
        
        return view
    }
    
}
