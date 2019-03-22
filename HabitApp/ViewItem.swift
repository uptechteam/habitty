//
//  ViewItem.swift
//  HabitApp
//
//  Created by Евгений Матвиенко on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import Foundation

struct ViewItem {
    struct Celebrity {
        var name: String
        var imageName: String
        var link: URL
    }

    enum DescriptionItem {
        case text(String)
        case links(title: String?, links: [URL])
        case image(name: String, description: String?)
        case celebrities(title: String, celebrities: [Celebrity])
    }

    var name: String
    var imageName: String
    var shortDescription: String
    var description: [DescriptionItem]
}

extension ViewItem {
    static func mockItems() -> [ViewItem] {
        return [
            ViewItem(
                name: "Healthy Guy",
                imageName: "healthy_guy.jpg",
                shortDescription: "Healthy Guy is even more healthy",
                description: [
                    .text(mockText),
                    .image(name: "healthy_guy.jpg", description: "123"),
                    .image(name: "healthy_guy.jpg", description: nil),
                    .links(title: "Links", links: [URL(string: "https://google.com")!]),
                    .celebrities(title: "Healthy guys", celebrities: [Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", link: URL(string: "https://google.com")!),Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", link: URL(string: "https://google.com")!),Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", link: URL(string: "https://google.com")!),Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", link: URL(string: "https://google.com")!),Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", link: URL(string: "https://google.com")!),Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", link: URL(string: "https://google.com")!)])
                ]
            ),
            ViewItem(
                name: "Healthy Guy",
                imageName: "healthy_guy.jpg",
                shortDescription: "Healthy Guy is even more healthy",
                description: [
                    .text(mockText),
                    .image(name: "healthy_guy.jpg", description: "123"),
                    .image(name: "healthy_guy.jpg", description: nil),
                    .links(title: "Links", links: [URL(string: "https://google.com")!]),
                    .celebrities(title: "Healthy guys", celebrities: [Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", link: URL(string: "https://google.com")!)])
                ]
            ),
            ViewItem(
                name: "Healthy Guy",
                imageName: "healthy_guy.jpg",
                shortDescription: "Healthy Guy is even more healthy",
                description: [
                    .text(mockText),
                    .image(name: "healthy_guy.jpg", description: "123"),
                    .image(name: "healthy_guy.jpg", description: nil),
                    .links(title: "Links", links: [URL(string: "https://google.com")!]),
                    .celebrities(title: "Healthy guys", celebrities: [Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", link: URL(string: "https://google.com")!)])
                ]
            )
        ]
    }
}

private let mockText = """
# Welcome to StackEdit!

Hi! I'm your first Markdown file in **StackEdit**. If you want to learn about StackEdit, you can read me. If you want to play with Markdown, you can edit me. Once you have finished with me, you can create new files by opening the **file explorer** on the left corner of the navigation bar
"""

let css =  """
h1 {
color: #7595de
}
"""
