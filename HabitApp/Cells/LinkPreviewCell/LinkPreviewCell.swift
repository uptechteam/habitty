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

    private lazy var views: [UIView] = [previewImageView, titleLabel, detailLabel]

    @IBOutlet weak var placeholderView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none
        UIView.animate(
            withDuration: 0.6,
            delay: 0,
            options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat],
            animations: {
                self.placeholderView.alpha = 0.6
            }
        )

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        contentView.addGestureRecognizer(tap)
    }

    var url: URL!
    var tapHandler: ((URL) -> Void)?
    func configure(with urlString: String, tapHandler: @escaping (URL) -> Void) {
        contentView.isUserInteractionEnabled = false
        views.forEach { $0.alpha = 0 }
        placeholderView.alpha = 1

        url = URL(string: urlString)!
        self.tapHandler = tapHandler

        LinkPreviewService.shared.makeLinkPreview(from: urlString) { [weak self] linkPreview in
            guard let linkPreview = linkPreview else { return }

            self?.contentView.isUserInteractionEnabled = true

            self?.previewImageView.image = linkPreview.image
            self?.titleLabel.text = linkPreview.title
            self?.detailLabel.text = linkPreview.detail

            UIView.animate(withDuration: 0.3, animations: {
                self?.placeholderView.alpha = 0
                self?.views.forEach { $0.alpha = 1 }
            })
        }
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        tapHandler?(url)
    }

}

