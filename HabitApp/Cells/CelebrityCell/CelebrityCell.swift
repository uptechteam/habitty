//
//  CelebrityCell.swift
//  HabitApp
//
//  Created by Mykhailo Palchuk on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import UIKit

class CelebrityCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!

    func setup(title: String, celebrities: [(ViewItem.Celebrity, () -> Void)]) {
        titleLabel.text = title

        scrollView.contentInset.left = 16
        scrollView.contentInset.right = 16

        for view in stackView.subviews {
            view.removeFromSuperview()
        }

        for (celebrity, tapHandler) in celebrities {
            let view = CelebrityView.makeNibInstance()
            view.setup(
                image: UIImage(named: celebrity.imageName)!,
                title: celebrity.name,
                tapHandler: tapHandler
            )
            stackView.addArrangedSubview(view)
        }
    }
}
