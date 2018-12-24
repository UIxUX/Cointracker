//
//  ProjectDetailHeaderViewCell.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/23/18.
//  Copyright © 2018 Org. All rights reserved.
//

import UIKit
import Pastel

protocol ProjectDetailHeaderViewCellDelegate {
    func notifyProjectChangeButtonPressed()
}

class ProjectDetailHeaderViewCell: UITableViewCell {
    @IBOutlet weak var projectImageView: UIImageView!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var projectImageViewLabel: UILabel!
    @IBOutlet weak var projectChangeButton: ForceTouchButton!
    
    var pastelView: PastelView!
    
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
        projectImageView.backgroundColor = .clear
        
        projectChangeButton.backgroundColor = UIColor.blueCardBackground
        projectChangeButton.applyShadow(intensity: .Strong)
        projectChangeButton.makeRounded()
        
        if pastelView == nil {
            let pastelView = PastelView(frame: projectImageView.bounds)
            pastelView.startPastelPoint = .bottomLeft
            pastelView.endPastelPoint = .topRight
            pastelView.animationDuration = 3.0

            pastelView.setColors([UIColor(red: 156/255, green: 39/255, blue: 176/255, alpha: 1.0),
                                  UIColor(red: 255/255, green: 64/255, blue: 129/255, alpha: 1.0),
                                  UIColor(red: 123/255, green: 31/255, blue: 162/255, alpha: 1.0),
                                  UIColor(red: 32/255, green: 76/255, blue: 255/255, alpha: 1.0),
                                  UIColor(red: 32/255, green: 158/255, blue: 255/255, alpha: 1.0),
                                  UIColor(red: 90/255, green: 120/255, blue: 127/255, alpha: 1.0),
                                  UIColor(red: 58/255, green: 255/255, blue: 217/255, alpha: 1.0)])
            
            pastelView.startAnimation()
            projectImageView.insertSubview(pastelView, at: 0)
            pastelView.layer.masksToBounds = true
            pastelView.makeRounded()
        }
    }
}
