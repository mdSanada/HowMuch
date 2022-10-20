//
//  Extension + UIImage.swift
//  Template
//
//  Created by Matheus D Sanada on 31/12/21.
//

import UIKit

extension UIImage {
    /// Render Image `alwaysOriginal`.
    var renderAsOriginal: UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }

    /// Render Image `alwaysTemplate`.
    var renderAsTemplate: UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}
