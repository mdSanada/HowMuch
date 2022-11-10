//
//  ReceiptTableViewCell.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 19/10/22.
//

import UIKit
import SnapKit

class ReceiptTableViewCell: UITableViewCell {
    @IBOutlet weak var imageReceipt: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelValue: UILabel!
    let label = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageReceipt.layer.cornerRadius = 10
        imageReceipt.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        label.removeFromSuperview()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func render(image: UIImage?, title: String, description: String, value: Decimal) {
        if let image = image {
            imageReceipt.image = image
        } else {
            imageReceipt.backgroundColor = .accent
            label.font = .systemFont(ofSize: 36, weight: .bold)
            label.text = String(title.first ?? "?").uppercased()
            label.textColor = .systemBackground
            imageReceipt.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerX.centerY.equalToSuperview()
            }
        }
        labelTitle.text = title
        labelDescription.text = description
        labelValue.text = value.asMoney()
    }
}
