//
//  Extension + UIColor.swift
//  SNMedicalTreatment
//
//  Created by Matheus D Sanada on 10/09/22.
//

import UIKit

extension UIColor {

    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat = 1) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: opacity)
    }

//    static let primary = UIColor(named: "Primary")!
//    static let secondary = UIColor(named: "Secondary")!
    static let accent = UIColor(named: "AccentColor")!
    static let pink = UIColor(named: "Pink")
//    static let background = UIColor(named: "Background")
//
//    static let title = UIColor(named: "Title")!
//    static let label = UIColor(named: "Label")!
//    static let secondatyLabel = UIColor(named: "SecondaryLabel")!
//    static let placeholder = UIColor(named: "Placeholder")!

    static func fromHex(_ hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
