//
//  ListCell.swift
//  HabitApp
//
//  Created by Евгений Матвиенко on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import UIKit

final class ListCell: UITableViewCell {
    static var reuseIdentifier: String {
        return "ListCell"
    }

    static var nib: UINib {
        return UINib(nibName: "ListCell", bundle: nil)
    }

    let previewView = PreviewView.makeNibInstance()

    @IBOutlet var previewContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        previewContainerView.clipsToBounds = true
        previewContainerView.layer.cornerRadius = 16

        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewContainerView.addSubview(previewView)
        previewContainerView.addConstraints([
            previewView.leadingAnchor.constraint(equalTo: previewContainerView.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor),
            previewView.topAnchor.constraint(equalTo: previewContainerView.topAnchor),
            previewView.bottomAnchor.constraint(equalTo: previewContainerView.bottomAnchor)
        ])
    }
}
