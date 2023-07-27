//
//  MainViewModel.swift
//  Flickr App
//
//  Created by user on 22.07.2023.
//

import Foundation
import Combine

protocol MainViewModelProtocol: AnyObject {
    var flickr: Flickr? {get set}
    var flickrInfo: [FlickrInfo] {get set}
    var imagesData: [Data] {get set}
    var sortDescription: [String] {get}
    var searchText: String {get set}
    var updateTableState: PassthroughSubject<TableState, Never> {get set}
    func fetchFlicer()
    func showPhotoController(index: Int)
    func showSortController()
    func sortArray(index: Int)
    func returnTegs(index: Int) -> String
}

final class MainViewModel: MainViewModelProtocol {
    var flickr: Flickr?
    var flickrInfo: [FlickrInfo] = []
    var imagesData: [Data] = []
    var searchText: String = "Стив Джобс"
    private let networkManager = NetworkManager.shared
    var coordinator: MainCoordinatorProtocol!
    let sortDescription: [String] = ["Сортировка", "По дате ↑", "По дате ↓", "По названию ↑", "По названию ↓"]
    var updateTableState = PassthroughSubject<TableState, Never>()
    
    //MARK: - fetchFlicer
    func fetchFlicer() {
        let russianWord = searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        networkManager.fetchFlickr(text: russianWord ?? "") { [unowned self] result in
            switch result {
            case .success(let flickr):
                self.flickr = flickr
                getPhoto()
            case .failure(let error):
                self.updateTableState.send(.failure)
                print(error)
            }
        }
    }
    
    //MARK: - getPhoto
    private func getPhoto() {
        guard let flickr = flickr else { return }
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            networkManager.fetchImage(photo: flickr.photos.photo) { result in
                switch result {
                case .success(let data):
                    self.imagesData = []
                    self.imagesData = data
                    self.getDescription()
                case .failure(let error):
                    print(error)
                    self.updateTableState.send(.failure)
                }
            }
        }
    }
    
    //MARK: - getDescription
    private func getDescription() {
        guard let flickr = flickr else { return }
        self.flickrInfo = []
        var index = 0 {
            didSet {
                DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
                    if index < flickr.photos.photo.count {
                        self.networkManager.fetchFlickrInfo(photoID: flickr.photos.photo[index]) { result in
                            switch result {
                            case .success(let info):
                                self.flickrInfo.append(info)
                                self.updateTableState.send(.success)
                                index += 1
                            case .failure(let error):
                                print(error)
                                self.updateTableState.send(.failure)
                            }
                        }
                    }
                }
            }
        }
        index = 0
    }
    
    //MARK: - showPhotoController
    func showPhotoController(index: Int) {
        coordinator.showPhotoController(imageData: imagesData[index])
    }
    
    //MARK: - showSortController
    func showSortController() {
        coordinator.showSortController()
    }
    
    func returnTegs(index: Int) -> String {
        var string = ""
        for i in flickrInfo[index].photo.tags.tag {
            if i.raw == flickrInfo[index].photo.tags.tag.last?.raw {
                string += "\(i.raw)"
            } else {
                string += "\(i.raw), "
            }
        }
        return string
    }
    
    //MARK: - sortArray
    func sortArray(index: Int) {
        switch index {
        case 1:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let arrayEnumerated = flickrInfo.enumerated()
            let newArraySorted = arrayEnumerated.sorted { formatter.date(from: $0.element.photo.dates.taken) ?? Date()  > formatter.date(from: $1.element.photo.dates.taken) ?? Date()}
            //сортировка фотографий
            var imagesSorted: [Data] = []
            for index in newArraySorted {
                let item = imagesData[index.offset]
                imagesSorted.append(item)
            }
            flickrInfo = newArraySorted.map {$0.element}
            imagesData = imagesSorted
            updateTableState.send(.success)

        case 2:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            let arrayEnumerated = flickrInfo.enumerated()
            let newArraySorted = arrayEnumerated.sorted { formatter.date(from: $0.element.photo.dates.taken) ?? Date()  < formatter.date(from: $1.element.photo.dates.taken) ?? Date()}
            //сортировка фотографий
            var imagesSorted: [Data] = []
            for index in newArraySorted {
                let item = imagesData[index.offset]
                imagesSorted.append(item)
            }
            flickrInfo = newArraySorted.map {$0.element}
            imagesData = imagesSorted
            updateTableState.send(.success)
        case 3:
            let arrayEnumerated = flickrInfo.enumerated()
            let newArraySorted = arrayEnumerated.sorted { $0.element.photo.title.content > $1.element.photo.title.content }
            //сортировка фотографий
            var imagesSorted: [Data] = []
            for index in newArraySorted {
                let item = imagesData[index.offset]
                imagesSorted.append(item)
            }
            flickrInfo = newArraySorted.map {$0.element}
            imagesData = imagesSorted
            updateTableState.send(.success)
        case 4:
            let arrayEnumerated = flickrInfo.enumerated()
            let newArraySorted = arrayEnumerated.sorted { $0.element.photo.title.content < $1.element.photo.title.content }
            //сортировка фотографий
            var imagesSorted: [Data] = []
            for index in newArraySorted {
                let item = imagesData[index.offset]
                imagesSorted.append(item)
            }
            flickrInfo = newArraySorted.map {$0.element}
            imagesData = imagesSorted
            updateTableState.send(.success)
        default:
            return
        }
    }
}
