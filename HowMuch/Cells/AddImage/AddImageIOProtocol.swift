//
//  AddImageIOProtocol.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 04/11/22.
//

import UIKit

protocol AddImageInputProtocol: AnyObject {
    func awake()
    func image(_ image: UIImage?)
}

protocol AddImageOutputProtocol: AnyObject {
    func setImage(_ image: UIImage?)
    func loadingImage(_ loading: Bool)
    func clean()
}
