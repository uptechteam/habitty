//
//  DetailsTableViewController.swift
//  HabitApp
//
//  Created by Mykhailo Palchuk on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController {

    static func getInstance() -> DetailsTableViewController {
        let storyboard = UIStoryboard(name: "DetailsTableViewController", bundle: nil)
        return storyboard.instantiateInitialViewController() as! DetailsTableViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(
            UINib(nibName: "ImageCell", bundle: nil),
            forCellReuseIdentifier: "ImageCell"
        )

        tableView.dataSource = self
        tableView.separatorStyle = .none
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
            cell.setup(image: UIImage(named: "johnny_cage.jpg")!, text: "This is Johnny and he is healthy. This is Johnny and he is. This is Johnny.")
            return cell
        case 1:
            let text = NSAttributedString(
                string: "Hey hey hey yo",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
            )
            let cell = UITableViewCell()
            cell.textLabel?.attributedText = text
            return cell
        case 2:
            let text = NSAttributedString(
                string: "Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was po",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.red]
            )
            let cell = UITableViewCell()
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.attributedText = text
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
            cell.setup(image: UIImage(named: "johnny_cage.jpg")!, text: "This is Johnny and he is healthy.")
            return cell
        }
    }
}
