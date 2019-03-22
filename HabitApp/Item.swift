//
//  Item.swift
//  HabitApp
//
//  Created by Mykhailo Palchuk on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import Foundation

struct Item: Codable {

    struct ImageDescriptionItem: Codable {
        let name: String
        let description: String?
    }

    struct CelebritiesDescriptionItem: Codable {
        let title: String
        let celebrities: [ViewItem.Celebrity]
    }

    enum DescriptionItem: Codable {
        case text(String)
        case link(URL)
        case image(ImageDescriptionItem)
        case celebrities(CelebritiesDescriptionItem)

        private enum CodingKeys: String, CodingKey {
            case type
            case value
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            let type = try container.decode(String.self, forKey: .type)
            switch type {
            case "text":
                self = .text(try container.decode(String.self, forKey: .value))
            case "link":
                self = .link(try container.decode(URL.self, forKey: .value))
            case "image":
                self = .image(try container.decode(ImageDescriptionItem.self, forKey: .value))
            case "celebrities":
                self = .celebrities(try container.decode(CelebritiesDescriptionItem.self, forKey: .value))
            default:
                fatalError()
            }
        }

        func encode(to encoder: Encoder) throws {
            fatalError()
        }
    }

    let name: String
    let imageName: String
    let shortDescription: String
    let description: [DescriptionItem]
}
