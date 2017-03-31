//
//  NewOrderCommentVC.swift
//  iPromatSwift
//
//  Created by Kudryaev, Grigoriy on 28.03.17.
//  Copyright © 2017 Kudryaev, Grigoriy. All rights reserved.
//

import UIKit

class NewOrderCommentVC: UITableViewController {

    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var splitSwitch: UISwitch!
    
    @IBAction func changeComment(segue:UIStoryboardSegue) {
        let vc = segue.source
        if let txt = vc.view.viewWithTag(123) as? UITextView {
            commentLabel.text = txt.text
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination
        if let txt = vc.view.viewWithTag(123) as? UITextView {
            txt.text = commentLabel.text
            txt.becomeFirstResponder()
        }
    }

}
