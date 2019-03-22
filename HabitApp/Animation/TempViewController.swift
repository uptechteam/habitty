//
//  TempViewController.swift
//  HabitApp
//
//  Created by Евгений Матвиенко on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import UIKit

final class TempViewController: UIViewController {
    let previewView = PreviewView.makeNibInstance()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        previewView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previewView)
        view.addConstraints([
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            previewView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        previewView.set(safeAreaTopLength: view.safeAreaInsets.top)
    }
}
