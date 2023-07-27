//
//  NetworkManager.swift
//  Flickr App
//
//  Created by user on 22.07.2023.
//

import Foundation

final class NetworkManager {
    private var networkService = NetworkService.shared
    static let shared = NetworkManager()
    
    private init() {}
    
    //MARK: - fetch flickr
    func fetchFlickr(text: String, completion: @escaping (Result<Flickr, Error>) -> Void) {
        let apiKey = "a340f6d4abf46452518a7a8ec6a42e15"
        let method = "flickr.photos.search"
        let page = "11"
        guard let url = URL(string: "https://api.flickr.com/services/rest/?api_key=\(apiKey)&format=json&method=\(method)&per_page=\(page)&text=\(text)&nojsoncallback=1") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        networkService.makeRequest(request: request, completion: completion)
    }
    
    //MARK: - fetchImage
    func fetchImage(photo: [Photo], size: String = "b", completion: @escaping (Result<[Data], Error>) -> Void) {
        var requestArray: [URLRequest] = []
        for item in photo {
            guard let url = URL(string: "https://farm\(item.farm).staticflickr.com/\(item.server)/\(item.id)_\(item.secret)_\(size).jpg") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            requestArray.append(request)
        }
        networkService.makeRequestArrayData(request: requestArray, completion: completion)
    }
    
    //MARK: - fetch flickrInfo
    func fetchFlickrInfo(photoID: Photo, completion: @escaping (Result<FlickrInfo, Error>) -> Void) {
        let apiKey = "a340f6d4abf46452518a7a8ec6a42e15"
        let method = "flickr.photos.getInfo"
        guard let url = URL(string: "https://api.flickr.com/services/rest/?method=\(method)&api_key=\(apiKey)&photo_id=\(photoID.id)&format=json&nojsoncallback=1") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        networkService.makeRequest(request: request, completion: completion)
    }
    
}
