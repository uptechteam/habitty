//
//  DetailsTableViewController.swift
//  HabitApp
//
//  Created by Mykhailo Palchuk on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import UIKit
import Down
import SafariServices

class DetailsTableViewController: UITableViewController {
    private let previewContainerView = UIView()
    private let previewView = PreviewView.makeNibInstance()
    private var item: ViewItem!
    private var willAppear = false

    override var prefersStatusBarHidden: Bool {
        return willAppear
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    static func getInstance() -> DetailsTableViewController {
        let storyboard = UIStoryboard(name: "DetailsTableViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DetailsTableViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
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

    private func setup() {
        tableView.register(
            UINib(nibName: "ImageCell", bundle: nil),
            forCellReuseIdentifier: "ImageCell"
        )
        tableView.register(
            UINib(nibName: "CelebrityCell", bundle: nil),
            forCellReuseIdentifier: "CelebrityCell"
        )
        tableView.register(
            UINib(nibName: "LinkPreviewCell", bundle: nil),
            forCellReuseIdentifier: "LinkPreviewCell"
        )
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.dataSource = self
        tableView.separatorStyle = .none

        previewContainerView.frame = CGRect(x: 0, y: 0, width: 0, height: 400)
        tableView.tableHeaderView = previewContainerView

        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewContainerView.addSubview(previewView)
        previewContainerView.addConstraints([
            previewView.leadingAnchor.constraint(equalTo: previewContainerView.leadingAnchor),
            previewView.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor),
            previewView.topAnchor.constraint(equalTo: previewContainerView.topAnchor),
            previewView.bottomAnchor.constraint(equalTo: previewContainerView.bottomAnchor)
        ])
    }

    func set(item: ViewItem) {
        previewView.set(viewItem: item)
        self.item = item
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let item = self.item else {
            fatalError()
        }

        return item.description.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.item else {
            fatalError()
        }

        return cell(for: item.description[indexPath.row])
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        previewView.transform = CGAffineTransform.identity
            .translatedBy(x: 0, y: min(0, scrollView.contentOffset.y - tableView.contentInset.top))
    }

    private func cell(for description: ViewItem.DescriptionItem) -> UITableViewCell {
        switch description {
        case .text(let text):
            return getTextCell(text: text)

        case .links(let title, let links):
            return getLinkCell(link: links.first ?? URL(string: "https://itunes.apple.com/ua/app/the-sims-mobile/id1144258115?mt=8")!)

        case .image(let imageName, let description):
            return getImageCell(image: imageName, description: description)

        case .celebrities(let title, let celebrities):
            return makeCelebritiesCell(title: title, celebrities: celebrities)
        }
    }

    private func getTextCell(text: String) -> UITableViewCell {
        let down = Down(markdownString: text)
        let text = try! down.toAttributedString(stylesheet: css)

        let cell = UITableViewCell()
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.attributedText = text
        return cell
    }

    private func getImageCell(image: String, description: String?) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
        cell.setup(image: UIImage(named: image)!, text: description ?? "")
        return cell
    }

    private func getLinkCell(link: URL) -> UITableViewCell {
        let linkPreviewCell = tableView.dequeueReusableCell(withIdentifier: "LinkPreviewCell") as! LinkPreviewCell
        linkPreviewCell.configure(with: "https://itunes.apple.com/ua/app/the-sims-mobile/id1144258115?mt=8")
        return linkPreviewCell
    }

    private func makeCelebritiesCell(title: String, celebrities: [ViewItem.Celebrity]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CelebrityCell") as! CelebrityCell
        let openUrl: (URL) -> Void = { url in
            let controller = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
        }
        var celebritiesParam: [(ViewItem.Celebrity, () -> Void)] = []
        for celebrity in celebrities {
            celebritiesParam.append((celebrity, { openUrl(celebrity.link) }))
        }
        cell.setup(title: title, celebrities: celebritiesParam)
        return cell
    }
}

extension DetailsTableViewController: PreviewAnimatedTransitioningViewController {
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
