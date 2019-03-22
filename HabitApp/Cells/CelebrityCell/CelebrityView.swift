//
//  CelebrityView.swift
//  HabitApp
//
//  Created by Mykhailo Palchuk on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import UIKit

class CelebrityView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    private var tap: (() -> Void)?

    static func getInstance() -> CelebrityView {
        let nib = UINib(nibName: "CelebrityView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! CelebrityView
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CelebrityView.handleTap)))
    }

    func setup(image: UIImage, title: String, tapHandler: (() -> Void)?) {
        imageView.image = image
        label.text = title
        tap = tapHandler
    }

    @objc private func handleTap() {
        tap?()
    }
}
