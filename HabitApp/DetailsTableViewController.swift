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

class DetailsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let tableView = UITableView()
    private let previewContainerView = UIView()
    private let previewView = PreviewView.makeNibInstance()
    private let closeButton = UIButton()
    private var item: ViewItem!
    private var willAppear = false

    private let styles = try! String(
        contentsOfFile: Bundle.main.path(forResource: "styles", ofType: "css")!
    )

    private var isCloseButtonLight = true {
        didSet {
            if oldValue != isCloseButtonLight {
                UIView.transition(with: closeButton, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.closeButton.setImage(self.isCloseButtonLight ? #imageLiteral(resourceName: "close_white") : #imageLiteral(resourceName: "close_black"), for: .normal)
                }, completion: nil)
            }
        }
    }

    override var prefersStatusBarHidden: Bool {
        return willAppear
    }

    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    static func makeStoryboardInstance() -> DetailsTableViewController {
        return DetailsTableViewController(nibName: nil, bundle: nil)
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.2) {
            self.closeButton.alpha = 1
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        previewView.set(topInset: view.safeAreaInsets.top)
    }

    private func setup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        view.addConstraints([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

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
        tableView.delegate = self
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

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(#imageLiteral(resourceName: "close_white"), for: .normal)
        closeButton.addTarget(self, action: #selector(DetailsTableViewController.handleCloseTap), for: .touchUpInside)
        closeButton.layer.zPosition = 100000
        closeButton.alpha = 0
        view.addSubview(closeButton)
        view.addConstraints([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }

    func set(item: ViewItem) {
        previewView.set(viewItem: item)
        self.item = item
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let item = self.item else {
            fatalError()
        }

        return item.description.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.item else {
            fatalError()
        }

        return cell(for: item.description[indexPath.row])
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        previewView.transform = CGAffineTransform.identity
            .translatedBy(x: 0, y: min(0, scrollView.contentOffset.y - tableView.contentInset.top))

        isCloseButtonLight = {
            if item.isImageLight {
                return false

            } else {
                return scrollView.contentOffset.y < (tableView.tableHeaderView?.frame.height ?? 0) - 20 - 14
            }
        }()
    }

    private func cell(for description: ViewItem.DescriptionItem) -> UITableViewCell {
        switch description {
        case .text(let text):
            return getTextCell(text: text)

        case .link(let link):
            return getLinkCell(link: link)

        case .image(let imageName, let description):
            return getImageCell(image: imageName, description: description)

        case .celebrities(let title, let celebrities):
            return makeCelebritiesCell(title: title, celebrities: celebrities)
        }
    }

    private func getTextCell(text: String) -> UITableViewCell {
        let down = Down(markdownString: text)
        let text = try! down.toAttributedString(stylesheet: styles)

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
        linkPreviewCell.configure(with: "https://itunes.apple.com/ua/app/the-sims-mobile/id1144258115?mt=8", tapHandler: self.open)
        return linkPreviewCell
    }

    private func makeCelebritiesCell(title: String, celebrities: [ViewItem.Celebrity]) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CelebrityCell") as! CelebrityCell
        var celebritiesParam: [(ViewItem.Celebrity, () -> Void)] = []
        for celebrity in celebrities {
            celebritiesParam.append((celebrity, { self.open(url: celebrity.url) }))
        }
        cell.setup(title: title, celebrities: celebritiesParam)
        return cell
    }

    private func open(url: URL) {
        let controller = SFSafariViewController(url: url)
        self.present(controller, animated: true, completion: nil)
    }

    @objc private func handleCloseTap() {
        UIView.animate(withDuration: 0.2, animations: {
            self.closeButton.alpha = 0

        }) { [weak self] _ in
            self?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
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
