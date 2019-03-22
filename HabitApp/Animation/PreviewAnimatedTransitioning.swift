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
    var previewTopInset: CGFloat { get }
    var previewCornerRadius: CGFloat { get }
    var previewImageInsets: UIEdgeInsets { get }
    var preferredTextWidth: CGFloat { get }
    func set(preferredTextWidth: CGFloat)
    func showPreviewView(on: Bool)
}

final class PreviewAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    private let duration: Double = 0.8

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

        fromViewController.showPreviewView(on: false)

        toViewController.view.alpha = 0
        toViewController.set(preferredTextWidth: fromViewController.preferredTextWidth)
        toViewController.showPreviewView(on: false)
        containerView.addSubview(toViewController.view)

        let previewView = PreviewView.makeNibInstance()
        previewView.set(viewItem: viewItem)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.set(topInset: fromViewController.previewTopInset)
        previewView.set(preferredTextWidth: fromViewController.preferredTextWidth)
        previewView.layer.cornerRadius = fromViewController.previewCornerRadius
        previewView.set(imageInsets: fromViewController.previewImageInsets)
        containerView.addSubview(previewView)

        let topConstraint = previewView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: fromViewController.previewViewFrame.minY)
        topConstraint.priority = UILayoutPriority(999)
        let leadingConstraint = previewView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: fromViewController.previewViewFrame.minX)
        leadingConstraint.priority = UILayoutPriority(999)
        let bottomConstraint = previewView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -(containerView.frame.height - fromViewController.previewViewFrame.maxY))
        bottomConstraint.priority = UILayoutPriority(999)
        let trailingConstraint = previewView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -(containerView.frame.width - fromViewController.previewViewFrame.maxX))
        trailingConstraint.priority = UILayoutPriority(999)

        containerView.addConstraints([
            topConstraint,
            leadingConstraint,
            bottomConstraint,
            trailingConstraint
        ])
        previewView.subviews.forEach { $0.layoutIfNeeded() }
        previewView.layoutIfNeeded()
        containerView.layoutIfNeeded()

        topConstraint.constant = toViewController.previewViewFrame.minY
        leadingConstraint.constant = toViewController.previewViewFrame.minX
        bottomConstraint.constant = -(containerView.frame.height - toViewController.previewViewFrame.maxY)
        trailingConstraint.constant = toViewController.previewViewFrame.width - toViewController.previewViewFrame.maxX
        previewView.set(topInset: toViewController.previewTopInset)
        previewView.set(preferredTextWidth: toViewController.preferredTextWidth)
        previewView.set(imageInsets: toViewController.previewImageInsets)

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
            toViewController.view.alpha = 1
            previewView.layer.cornerRadius = toViewController.previewCornerRadius
            previewView.subviews.forEach { $0.layoutIfNeeded() }
            previewView.layoutIfNeeded()
            containerView.layoutIfNeeded()

        }) { _ in
            fromViewController.showPreviewView(on: true)
            toViewController.showPreviewView(on: true)

            fromViewController.view.removeFromSuperview()
            previewView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
