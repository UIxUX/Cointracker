//
//  ProjectDetailHeaderViewCell.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/23/18.
//  Copyright © 2018 Org. All rights reserved.
//

import UIKit

protocol ProjectDetailHeaderViewCellDelegate {
    func notifyProjectChangeButtonPressed()
}

class ProjectDetailHeaderViewCell: UITableViewCell {
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var projectImageViewLabel: UILabel!
    @IBOutlet weak var projectChangeButton: ForceTouchButton!
    
    var delegate: ProjectDetailHeaderViewCellDelegate?
    
    func setProjectLabel(string: String) {
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(1.3), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica", size: 20.0)!, range: NSMakeRange(0, (attributedString.length)))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(white: 1.0, alpha: 1.00), range: NSMakeRange(0, (attributedString.length)))
        
        projectLabel.attributedText = attributedString
    }
    
    func setProjectImageView(image: UIImage) {
        projectImageView.image = image
    }
    
    func setProjectImageViewLabel(string: String) {
        projectImageViewLabel.text = string
    }
    
    @IBAction func projectChangeButtonPressed(_ sender: UIButton) {
        delegate?.notifyProjectChangeButtonPressed()
    }
    
    
    override func awakeFromNib() {
        self.backgroundColor = .clear
        self.backgroundView?.backgroundColor = .clear
        projectImageView.backgroundColor = .white
        
        projectLabel.textDropShadow()
        
        projectImageView.applyShadow(intensity: .Strong)
        projectImageView.makeRounded()
        
        projectChangeButton.backgroundColor = UIColor.blueCardBackground
        projectChangeButton.applyShadow(intensity: .Strong)
        projectChangeButton.makeRounded()
        
    }
}
