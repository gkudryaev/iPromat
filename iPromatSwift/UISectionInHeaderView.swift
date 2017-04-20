//
//  UISectionInHeaderView.swift
//  iPromatSwift
//
//  Created by Grisha on 4/18/17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class UISectionInHeaderView: UIView {
    
    var labelString: String = ""
    var commentString: String = ""
    
    func header (labelString: String, commentString: String)  {
        self.labelString = labelString
        self.commentString = commentString

        self.backgroundColor = AppModule.sectionBkColor
        
        let label = UILabel()
        label.text = labelString
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.lightGray
        label.font = label.font.withSize(17)

        let comment = UILabel()
        comment.text = commentString
        comment.translatesAutoresizingMaskIntoConstraints = false
        comment.textColor = UIColor.lightGray
        comment.font = comment.font.withSize(15)
        comment.numberOfLines = 2
        comment.lineBreakMode = .byWordWrapping

        
        let views = ["label": label,"comment":comment,"view": self]
        self.addSubview(label)
        self.addSubview(comment)
        let vc1 = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[label]-10-[comment]-10-|", options: .alignAllCenterX, metrics: nil, views: views)
        self.addConstraints(vc1)
        
        let hc1 = NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0)
        self.addConstraint(hc1)
        let hc2 = NSLayoutConstraint(item: comment, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leadingMargin, multiplier: 1, constant: 0)
        self.addConstraint(hc2)

    }
    


}
