//
//  LinkPreviewCell.swift
//  HabitApp
//
//  Created by Tolgahan Arıkan on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import UIKit

class LinkPreviewCell: UITableViewCell {

    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(with linkPreview: LinkPreview) {
        previewImageView.image = linkPreview.image
        titleLabel.text = linkPreview.title
        detailLabel.text = linkPreview.detail
    }

}
