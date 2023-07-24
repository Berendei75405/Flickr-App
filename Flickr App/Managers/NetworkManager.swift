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
        var requestsArray: [URLRequest] = []
        for i in photo {
            guard let url = URL(string: "https://farm\(i.farm).staticflickr.com/\(i.server)/\(i.id)_\(i.secret)_\(size).jpg") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            requestsArray.append(request)
        }
        networkService.makeRequestArrayData(request: requestsArray, completion: completion)
    }
    
    //MARK: - fetch flickrInfo
    func fetchFlickrInfo(photoID: [Photo], completion: @escaping (Result<[FlickrInfo], Error>) -> Void) {
        let apiKey = "a340f6d4abf46452518a7a8ec6a42e15"
        let method = "flickr.photos.getInfo"
        var requestsArray: [URLRequest] = []
        for item in photoID {
            guard let url = URL(string: "https://api.flickr.com/services/rest/?method=\(method)&api_key=\(apiKey)&photo_id=\(item.id)&format=json&nojsoncallback=1") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            requestsArray.append(request)
        }
        networkService.makeRequestArray(request: requestsArray, completion: completion)
    }
    
}
