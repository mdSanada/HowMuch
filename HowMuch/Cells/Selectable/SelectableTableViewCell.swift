//
//  SelectableTableViewCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 25/10/22.
//

import UIKit

class SelectableTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonChange: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func render(title: String, actions: [String], default: Int = 0) {
        var children: [UIAction] = []
        actions.forEach { title in
            let action = UIAction(title: title) { [weak self] (action) in
                self?.labelTitle.text = action.title
           }
            children.append(action)
        }

        let menu = UIMenu(title: title, options: .displayInline, children: children)
        buttonChange.menu = menu
        buttonChange.showsMenuAsPrimaryAction = true
        labelTitle.text = actions[`default`]
    }
}
