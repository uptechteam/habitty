//
//  PreviewAnimatedTransitioning.swift
//  HabitApp
//
//  Created by Евгений Матвиенко on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import UIKit

protocol PreviewAnimatedTransitioningViewController {
    var previewViewFrame: CGRect { get }
    var previewViewItem: ViewItem? { get }
}

final class PreviewAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: Double = 0.5

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard
            let fromViewController = transitionContext.viewController(forKey: .from) as? UIViewController & PreviewAnimatedTransitioningViewController,
            let toViewController = transitionContext.viewController(forKey: .to) as? UIViewController & PreviewAnimatedTransitioningViewController,
            let viewItem = fromViewController.previewViewItem
        else {
            return
        }

        toViewController.view.alpha = 0
        containerView.addSubview(toViewController.view)

        let previewView = PreviewView.makeNibInstance()
        previewView.set(viewItem: viewItem)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(previewView)

        let topConstraint = previewView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: fromViewController.previewViewFrame.minY)
        topConstraint.priority = UILayoutPriority(999)
        let leadingConstraint = previewView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: fromViewController.previewViewFrame.minX)
        leadingConstraint.priority = UILayoutPriority(999)
        let widthConstraint = previewView.widthAnchor.constraint(equalToConstant: fromViewController.previewViewFrame.width)
        widthConstraint.priority = UILayoutPriority(999)
        let heightConstraint = previewView.heightAnchor.constraint(equalToConstant: fromViewController.previewViewFrame.height)
        heightConstraint.priority = UILayoutPriority(999)

        containerView.addConstraints([
            topConstraint,
            leadingConstraint,
            widthConstraint,
            heightConstraint
        ])
        containerView.layoutSubviews()

        topConstraint.constant = toViewController.previewViewFrame.minY
        leadingConstraint.constant = toViewController.previewViewFrame.minX
        widthConstraint.constant = toViewController.previewViewFrame.width
        heightConstraint.constant = toViewController.previewViewFrame.height

        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.alpha = 1
            containerView.layoutSubviews()

        }) { _ in
            fromViewController.view.removeFromSuperview()
            previewView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
