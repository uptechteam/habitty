//
//  ViewItem.swift
//  HabitApp
//
//  Created by Евгений Матвиенко on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import Foundation

struct ViewItem {
    struct Celebrity: Codable {
        var name: String
        var imageName: String
        var url: URL
    }

    enum DescriptionItem {
        case text(String)
        case link(URL)
        case image(name: String, description: String?)
        case celebrities(title: String, celebrities: [Celebrity])
    }

    var name: String
    var imageName: String
    var isImageLight: Bool
    var shortDescription: String
    var description: [DescriptionItem]
}

extension ViewItem {
    static func mockItems() -> [ViewItem] {
        return [
            ViewItem(
                name: "Healthy Guy Healthy Guy Healthy Guy Healthy Guy",
                imageName: "jedi.jpg",
                isImageLight: false,
                shortDescription: "Healthy Guy is even more healthy",
                description: [
                    .text(mockText),
                    .image(name: "healthy_guy.jpg", description: "123"),
                    .image(name: "healthy_guy.jpg", description: nil),
                    .link(URL(string: "https://google.com")!),
                    .celebrities(title: "Healthy guys", celebrities: [Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", url: URL(string: "https://google.com")!),Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", url: URL(string: "https://google.com")!),Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", url: URL(string: "https://google.com")!),Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", url: URL(string: "https://google.com")!),Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", url: URL(string: "https://google.com")!),Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", url: URL(string: "https://google.com")!)])
                ]
            ),
            ViewItem(
                name: "Healthy Guy",
                imageName: "jedi.jpg",
                isImageLight: false,
                shortDescription: "Healthy Guy is even more healthy",
                description: [
                    .text(mockText),
                    .image(name: "healthy_guy.jpg", description: "123"),
                    .image(name: "healthy_guy.jpg", description: nil),
                    .link(URL(string: "https://google.com")!),
                    .celebrities(title: "Healthy guys", celebrities: [Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", url: URL(string: "https://google.com")!)])
                ]
            ),
            ViewItem(
                name: "Healthy Guy",
                imageName: "healthy_guy.jpg",
                isImageLight: true,
                shortDescription: "Healthy Guy is even more healthy",
                description: [
                    .text(mockText),
                    .image(name: "healthy_guy.jpg", description: "123"),
                    .image(name: "healthy_guy.jpg", description: nil),
                    .link(URL(string: "https://google.com")!),
                    .celebrities(title: "Healthy guys", celebrities: [Celebrity(name: "Johnny Cage", imageName: "johnny_cage.jpg", url: URL(string: "https://google.com")!)])
                ]
            )
        ]
    }
}

private let mockText = """
# Welcome to StackEdit!

Hi! I'm your first Markdown file in **StackEdit**. If you want to learn about StackEdit, you can read me. If you want to play with Markdown, you can edit me. Once you have finished with me, you can create new files by opening the **file explorer** on the left corner of the navigation bar
"""
