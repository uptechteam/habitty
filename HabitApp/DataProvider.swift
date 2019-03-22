//
//  DataProvider.swift
//  HabitApp
//
//  Created by Mykhailo Palchuk on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import Foundation

class DataProvider {
    static func getData() -> [ViewItem] {
        do {
            let url = Bundle.main.url(forResource: "data", withExtension: ".json")!
            let items = try JSONDecoder().decode([Item].self, from: Data(contentsOf: url))
            return items.map { item in
                return ViewItem(
                    name: item.name,
                    imageName: item.imageName,
                    isImageLight: item.isImageLight,
                    shortDescription: item.shortDescription,
                    description: item.description.map { description in
                        switch description {
                        case .text(let text):
                            return .text(text)
                        case .link(let url):
                            return .link(url)
                        case .image(let image):
                            return .image(name: image.name, description: image.description)
                        case .celebrities(let item):
                            return .celebrities(title: item.title, celebrities: item.celebrities)
                        }
                    }
                    )
            }
        } catch {
            print(error)
            fatalError()
        }
    }
}
