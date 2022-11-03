//
//  ReceiptTableViewCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 19/10/22.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {
    @IBOutlet weak var imageReceipt: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageReceipt.layer.cornerRadius = 10
        imageReceipt.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func render(image: UIImage?, title: String, description: String, value: Decimal) {
        imageReceipt.image = image
        labelTitle.text = title
        labelDescription.text = description
        labelValue.text = value.asMoney()
    }
}
