//
//  ListViewController.swift
//  HabitApp
//
//  Created by Евгений Матвиенко on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    static func makeStoryboardInstance() -> ListViewController {
        return UIStoryboard(name: "ListViewController", bundle: nil).instantiateInitialViewController() as! ListViewController
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    override var prefersStatusBarHidden: Bool {
        return !willAppear
    }

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var underView: UIView!
    
    private var selectedCellIndexPath: IndexPath?
    private var willAppear = false

    private let items = DataProvider.getData()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ListCell.nib, forCellReuseIdentifier: ListCell.reuseIdentifier)
        tableView.rowHeight = 400
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = false

        setupHeaderView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        willAppear = true
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        willAppear = false
    }

    private func setupHeaderView() {
        let headerView = UIView()
        headerView.frame = CGRect(x: 0, y: 0, width: 0, height: 200)
        tableView.tableHeaderView = headerView

        let welcomeLabel = UILabel()
        welcomeLabel.text = "Hi there!"
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.heavy)
        welcomeLabel.textColor = UIColor(red:0.10, green:0.10, blue:0.10, alpha:1.0)

        let callToActionLabel = UILabel()
        callToActionLabel.text = "Let's find you a new habit"
        callToActionLabel.textAlignment = .center
        callToActionLabel.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.bold)
        callToActionLabel.textColor = UIColor(red:0.20, green:0.20, blue:0.20, alpha:1.0)

        let labelStackView = UIStackView(arrangedSubviews: [welcomeLabel, callToActionLabel])
        labelStackView.axis = .vertical
        labelStackView.spacing = 8

        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(labelStackView)
        NSLayoutConstraint.activate([
            labelStackView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            labelStackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            labelStackView.widthAnchor.constraint(equalTo: headerView.widthAnchor, constant: -32)
        ])
    }
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier, for: indexPath) as! ListCell
        cell.previewView.set(viewItem: items[indexPath.row])
        return cell
    }
}

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndexPath = indexPath

        let vc = DetailsTableViewController.makeStoryboardInstance()
        vc.set(item: items[indexPath.row])
        vc.transitioningDelegate = self
        present(vc, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ListCell else {
            return
        }

        cell.previewView.set(preferredTextWidth: preferredTextWidth)
        cell.previewView.set(imageInsets: previewImageInsets)
    }
}

extension ListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PreviewAnimatedTransitioning()
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PreviewAnimatedTransitioning()
    }
}

extension ListViewController: PreviewAnimatedTransitioningViewController {
    var previewViewFrame: CGRect {
        guard let indexPath = selectedCellIndexPath, let cell = tableView.cellForRow(at: indexPath) as? ListCell else {
            return .zero
        }

        let frame1 = tableView.convert(cell.previewContainerView.frame, from: cell)
        let frame2 = self.view.convert(frame1, from: tableView)
        return frame2
    }

    var previewViewItem: ViewItem? {
        return selectedCellIndexPath.map { items[$0.row] }
    }

    var previewTopInset: CGFloat {
        return 0
    }

    var previewCornerRadius: CGFloat {
        return 16
    }

    var preferredTextWidth: CGFloat {
        return view.frame.width - 32 * 2
    }

    var previewImageInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -view.safeAreaInsets.top, left: -16, bottom: 0, right: -16)
    }

    func set(preferredTextWidth: CGFloat) { }

    func showPreviewView(on: Bool) {
        guard let indexPath = selectedCellIndexPath, let cell = tableView.cellForRow(at: indexPath) as? ListCell else {
            return
        }

        cell.previewView.alpha = on ? 1 : 0

        if previewViewFrame.intersects(underView.frame) {
            underView.alpha = on ? 1 : 0
        }
    }
}
