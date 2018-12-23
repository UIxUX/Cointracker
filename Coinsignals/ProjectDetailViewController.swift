//
//  ProjectDetailViewController.swift
//  Coinsignals
//
//  Created by Julian Praest on 12/23/18.
//  Copyright © 2018 Org. All rights reserved.
//

import UIKit

class ProjectDetailViewController: UITableViewController {
    
    var selectedProject: Project!
    var selectedPeriod: Period!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        selectedProject = .BTC
        selectedPeriod = .Alltime
    }
    
    
    fileprivate func setupTableView() {
        tableView.backgroundColor = .clear
        view.backgroundColor = .clear
        let gradientView = UIView(frame: self.view.frame)
        gradientView.addGradient(colors: [UIColor.blueBackgroundTop.cgColor, UIColor.blueBackgroundBottom.cgColor])
        tableView.backgroundView = gradientView
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 200))
        
        let row = indexPath.row
        switch row {
        case 0:
            ///HeaderCell
            cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailHeaderViewCell", for: indexPath)
            cell.frame.size.width = self.tableView.frame.width
            if let _cell = cell as? ProjectDetailHeaderViewCell {
                _cell.setProjectLabel(string: "BITCOIN")
                _cell.projectImageViewLabel.text = selectedProject.unicode()
            }
            break
        case 1:
            ///ProjectDetailSimpleOverViewCell
            cell = tableView.dequeueReusableCell(withIdentifier: "ProjectDetailSimpleOverViewCell", for: indexPath)
            if let _cell = cell as? ProjectDetailSimpleOverViewCell {
               _cell.setPriceLabel(string: "4132$")
                _cell.setBubbleText(string: "+15%", bubble: _cell.priceChangedButton)
                _cell.setBubbleText(string: "OVERSOLD", bubble: _cell.rsiValueButton)
                _cell.setBubbleText(string: "GREAT", bubble: _cell.sentimentValueButton)
            }
            break
        default:
            break
        }
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //Hides status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
