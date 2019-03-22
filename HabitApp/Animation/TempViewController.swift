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

    override var prefersStatusBarHidden: Bool {
        return true
    }

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

        view.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(TempViewController.handleTap)
            )
        )
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        previewView.set(safeAreaTopLength: view.safeAreaInsets.top)
    }

    @objc private func handleTap() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension TempViewController: PreviewAnimatedTransitioningViewController {
    var previewViewFrame: CGRect {
        return previewView.frame
    }

    var previewViewItem: ViewItem? {
        return previewView.viewItem
    }
}
