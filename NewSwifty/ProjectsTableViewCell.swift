//
//  ProjectsTableViewCell.swift
//  SwiftyCompanion
//
//  Created by Danil Vdovenko on 1/30/18.
//  Copyright © 2018 Danil Vdovenko. All rights reserved.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell {

    @IBOutlet weak var projectMark: UILabel!
    @IBOutlet weak var projectName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setProjects(with project: Projects) {
        if let name = project.name {
            if let mark = project.mark {
                if let success = project.success {
                    projectName.text = name
                    if success && mark != 0 {
                        setMark(with: UIColor(red:0.38, green:0.67, blue:0.03, alpha:1.0), contain: "\(String(format: "%2d", mark))")
                    } else {
                        setMark(with: UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0), contain: "\(String(format: "%2d", mark))")
                    }
                }
            }
        }
    }
    
    func setMark(with color: UIColor, contain text: String) {
        projectMark.text = text
        projectMark.textColor = color
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
