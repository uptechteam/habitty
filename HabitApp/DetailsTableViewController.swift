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
    var item: ViewItem? = ViewItem.mockItems()[0]

    static func makeStoryboardInstance() -> DetailsTableViewController {
        let storyboard = UIStoryboard(name: "DetailsTableViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DetailsTableViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
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

        tableView.dataSource = self
        tableView.separatorStyle = .none

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
}
