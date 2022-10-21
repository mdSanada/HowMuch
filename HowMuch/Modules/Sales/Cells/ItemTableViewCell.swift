//
//  ItemTableViewCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 20/10/22.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func render(title: String, value: String) {
        labelTitle.text = title
        labelValue.text = value
    }
    
}
