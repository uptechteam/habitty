//
//  PreviewView.swift
//  HabitApp
//
//  Created by Евгений Матвиенко on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import UIKit

final class PreviewView: UIView {
    static func makeNibInstance() -> PreviewView {
        return UINib(nibName: "PreviewView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! PreviewView
    }

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var titleTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(safeAreaTopLength: CGFloat) {
        titleTopConstraint.constant = safeAreaTopLength + 16
    }

    func set(viewItem: ViewItem) {
        imageView.image = UIImage(named: viewItem.imageName)
        titleLabel.text = viewItem.name
        descriptionLabel.text = viewItem.shortDescription
    }
}
