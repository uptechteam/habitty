//
//  LinkPreviewService.swift
//  HabitApp
//
//  Created by Tolgahan Arıkan on 3/22/19.
//  Copyright © 2019 Tolgahan Arıkan. All rights reserved.
//

import Foundation
import SwiftLinkPreview
import UIKit

class LinkPreviewService {
    private let imageCache = NSCache<AnyObject, AnyObject>()
    private let swiftLinkPreview = SwiftLinkPreview(cache: InMemoryCache())

    static let shared = LinkPreviewService()

    private init() {}

    func makeLinkPreview(from urlText: String, completion: @escaping (LinkPreview?) -> Void) {
        if let cached = swiftLinkPreview.cache.slp_getCachedResponse(url: urlText) {
            guard
                let imageUrlString = cached[SwiftLinkResponseKey.image] as? String,
                let title = cached[SwiftLinkResponseKey.title] as? String,
                let description = cached[SwiftLinkResponseKey.description] as? String
            else { completion(nil); return }

            if let imageFromCache = imageCache.object(forKey: imageUrlString as AnyObject) as? UIImage {
                let linkPreview = LinkPreview(
                    image: imageFromCache,
                    title: title,
                    detail: description
                )
                completion(linkPreview)
                return
            }
        }

        swiftLinkPreview.preview(urlText, onSuccess: { [weak self] response in
            guard
                let imageUrlString = response[SwiftLinkResponseKey.image] as? String,
                let title = response[SwiftLinkResponseKey.title] as? String,
                let description = response[SwiftLinkResponseKey.description] as? String,
                let imageUrl = URL(string: imageUrlString)
                else { completion(nil); return }

            self?.downloadImage(from: imageUrl) { image in
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

    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        getData(from: url) { [weak self] data, response, error in
            guard let data = data, error == nil else { return completion(nil) }
            DispatchQueue.main.async() {
                let image = UIImage(data: data)
                self?.imageCache.setObject(image!, forKey: url.absoluteString as AnyObject)
                completion(image)
            }
        }
    }
}
