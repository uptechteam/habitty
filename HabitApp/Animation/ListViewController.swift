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

    @IBOutlet private var tableView: UITableView!

    private let items = ViewItem.mockItems()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(ListCell.nib, forCellReuseIdentifier: ListCell.reuseIdentifier)
        tableView.rowHeight = 400
        tableView.delegate = self
        tableView.dataSource = self
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
        let viewController = TempViewController(nibName: nil, bundle: nil)
        viewController.previewView.set(viewItem: items[indexPath.row])
        present(viewController, animated: true, completion: nil)
    }
}
