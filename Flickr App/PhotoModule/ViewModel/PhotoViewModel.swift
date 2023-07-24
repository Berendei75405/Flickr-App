//
//  PhotoViewModel.swift
//  Flickr App
//
//  Created by user on 22.07.2023.
//

import Foundation

protocol PhotoViewModelProtocol: AnyObject {
    var imageData: Data {get set}
    func closePhotoViewController()
}

final class PhotoViewModel: PhotoViewModelProtocol {
    var coordinator: MainCoordinatorProtocol!
    var imageData: Data = Data()
    
    //MARK: - closePhotoViewController
    func closePhotoViewController() {
        coordinator?.dismissToRoot()
    }
    
}
