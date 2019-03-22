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

    private var willAppear = false

    override var prefersStatusBarHidden: Bool {
        return willAppear
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.set(imageInsets: previewImageInsets)
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        willAppear = true
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        previewView.set(topInset: view.safeAreaInsets.top)
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

    var previewTopInset: CGFloat {
        return view.safeAreaInsets.top
    }

    var previewCornerRadius: CGFloat {
        return 0
    }

    var preferredTextWidth: CGFloat {
        return previewView.frame.width - 16 * 2
    }

    var previewImageInsets: UIEdgeInsets {
        return .zero
    }

    func set(preferredTextWidth: CGFloat) {
        previewView.set(preferredTextWidth: preferredTextWidth)
    }

    func showPreviewView(on: Bool) {
        previewView.alpha = on ? 1 : 0
    }
}
