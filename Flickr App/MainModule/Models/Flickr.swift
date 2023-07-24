//
//  MainModel.swift
//  Flickr App
//
//  Created by user on 22.07.2023.
//

import Foundation

// MARK: - Flickr
struct Flickr: Codable {
    let photos: Photos
}

// MARK: - Photos
struct Photos: Codable {
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, secret, server: String
    let farm: Int
    let title: String
}
