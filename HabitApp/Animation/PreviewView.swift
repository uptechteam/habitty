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
    @IBOutlet private var titleWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var descriptionWidthConstraint: NSLayoutConstraint!
    @IBOutlet private var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet private var imageLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var imageBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var imageTrailingConstraint: NSLayoutConstraint!

    private(set) var viewItem: ViewItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(topInset: CGFloat) {
        titleTopConstraint.constant = max(topInset, 12)
    }

    func set(preferredTextWidth: CGFloat) {
        titleWidthConstraint.constant = preferredTextWidth
        descriptionWidthConstraint.constant = preferredTextWidth
    }

    func set(viewItem: ViewItem) {
        self.viewItem = viewItem
        imageView.image = UIImage(named: viewItem.imageName)
        titleLabel.text = viewItem.name
        titleLabel.textColor = viewItem.isImageLight ? UIColor.darkText : .white
        descriptionLabel.text = viewItem.shortDescription
        descriptionLabel.textColor = viewItem.isImageLight ? UIColor.darkText : .white
    }

    func set(imageInsets: UIEdgeInsets) {
        imageTopConstraint.constant = imageInsets.top
        imageLeadingConstraint.constant = imageInsets.left
        imageTrailingConstraint.constant = imageInsets.right
        imageBottomConstraint.constant = imageInsets.bottom
    }
}
