//
//  ParallaxGroupedSectionHeaderTableView.swift
//  HowMuch
//
//  Created by Matheus D Sanada on 20/10/22.
//

import UIKit

public class ParallaxGroupedSectionHeaderTableView: UITableView {

    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutHeaderViews()
    }

    private func layoutHeaderViews() {
        for index in 0 ..< numberOfSections {
            guard let sectionView = headerView(forSection: index) else { continue }
            self.sendSubviewToBack(sectionView)
        }
    }
}
