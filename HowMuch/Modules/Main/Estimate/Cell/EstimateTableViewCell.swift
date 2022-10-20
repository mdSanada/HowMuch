//
//  EstimateTableViewCell.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 10/10/22.
//

import UIKit

class EstimateTableViewCell: UITableViewCell {

    @IBOutlet weak var viewCircleStatus: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imagePet: UIImageView!
    @IBOutlet weak var labelDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        viewCircleStatus.layer.cornerRadius = viewCircleStatus.bounds.height / 2
        viewCircleStatus.layer.masksToBounds = true
        imagePet.contentMode = .scaleToFill
        imagePet.layer.cornerRadius = imagePet.bounds.height / 2
        imagePet.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func render(title: String,
                       date: Date,
                       status: Status,
                       pet: UIImage?) {
        labelTitle.text = title
        labelDate.text = date.string(pattern: .numeric)
        imagePet.image = pet
        viewCircleStatus.backgroundColor = status.color()
    }
}
