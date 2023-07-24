//
//  FlickrInfo.swift
//  Flickr App
//
//  Created by user on 22.07.2023.
//

import Foundation

// MARK: - Flickr
struct FlickrInfo: Codable {
    let photo: Image
}

// MARK: - Dates
struct Dates: Codable {
    let taken: String
}

struct Image: Codable {
    let dates: Dates
    let tags: Tags
    let title: Title
}

// MARK: - Tags
struct Tags: Codable {
    let tag: [Tag]
}

// MARK: - Tag
struct Tag: Codable {
    let raw: String
}

struct Title: Codable {
    let content: String
    enum CodingKeys: String, CodingKey {
        case content = "_content"
    }
}
