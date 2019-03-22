//
//  LinkPreviewService.swift
//  HabitApp
//
//  Created by Tolgahan Arıkan on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import Foundation
import SwiftLinkPreview

class LinkPreviewService {
    private let swiftLinkPreview = SwiftLinkPreview()

    static let shared = LinkPreviewService()

    private init() {}

    func makeLinkPreview(from urlText: String, completion: @escaping (LinkPreview?) -> Void) {
        swiftLinkPreview.preview(urlText, onSuccess: { response in
            guard
                let imageUrlString = response[SwiftLinkResponseKey.image] as? String,
                let title = response[SwiftLinkResponseKey.title] as? String,
                let description = response[SwiftLinkResponseKey.description] as? String,
                let imageUrl = URL(string: imageUrlString)
                else { completion(nil); return }

            downloadImage(from: imageUrl) { image in
                if let image = image {
                    let linkPreview = LinkPreview(
                        image: image,
                        title: title,
                        detail: description
                    )
                    completion(linkPreview)
                } else {
                    completion(nil)
                }
            }
        }) { _ in
            completion(nil)
        }
    }
}

private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
}

private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    getData(from: url) { data, response, error in
        guard let data = data, error == nil else { return completion(nil) }
        DispatchQueue.main.async() {
            completion(UIImage(data: data))
        }
    }
}
