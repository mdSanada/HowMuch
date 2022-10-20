//
//  MaterialsTableViewCell.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 10/10/22.
//

import UIKit

class MaterialsTableViewCell: UITableViewCell {
    @IBOutlet weak var labelPet: UILabel!
    
    @IBOutlet weak var imagePet: UIImageView!
    @IBOutlet weak var labelBreed: UILabel!
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelWeight: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imagePet.contentMode = .scaleToFill
        imagePet.layer.cornerRadius = imagePet.bounds.height / 2
        imagePet.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func render(name: String, breed: String, age: Int, weight: Int, pet: UIImage?) {
        labelPet.text = name
        labelBreed.text = breed
        labelAge.text = String(age) + "anos"
        labelWeight.text = String(weight) + "kg"
        imagePet.image = pet
    }
}
