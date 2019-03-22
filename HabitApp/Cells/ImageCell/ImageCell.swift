//
//  ImageCell.swift
//  HabitApp
//
//  Created by Mykhailo Palchuk on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    func setup(image: UIImage, text: String) {
        cellImageView.image = image
        label.text = text
    }
}
