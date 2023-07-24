//
//  Coordinator.swift
//  Flickr App
//
//  Created by user on 22.07.2023.
//

import UIKit

protocol MainCoordinatorProtocol: AnyObject {
    func initialViewController()
    func createModule() -> UIViewController
    func createPhotoController() -> UIViewController
    func showPhotoController(imageData: Data)
    func dismissToRoot()
    func showSortController()
}

final class Coordinator: MainCoordinatorProtocol {
    private var navCon: UINavigationController?
    
    //MARK: - init
    init(navCon: UINavigationController) {
        self.navCon = navCon
    }
    
    //MARK: - initialViewController
    func initialViewController() {
        if let navCon = navCon {
            let view = createModule()
            
            navCon.viewControllers = [view]
        }
    }
    
    //MARK: - createModule
    func createModule() -> UIViewController {
        let view = MainViewController()
        let sortView = SortViewController()
        let viewModel = MainViewModel()
        let coordinator = self
        
        view.viewModel = viewModel
        view.sortViewController = sortView
        viewModel.coordinator = coordinator
        
        return view
    }
    
    //MARK: - createPhotoController
    func createPhotoController() -> UIViewController {
        let view = PhotoViewController()
        let viewModel = PhotoViewModel()
        let coordinator = self
        
        view.viewModel = viewModel
        viewModel.coordinator = coordinator
        
        return view
    }
    
    //MARK: - showPhotoController
    func showPhotoController(imageData: Data) {
        guard let view = createPhotoController() as? PhotoViewController else { return }
        view.viewModel.imageData = imageData
        
        guard let navCon = navCon else { return }
        navCon.present(view, animated: true)
    }
    
    //MARK: - dismissToRoot
    func dismissToRoot() {
        if let navCon = navCon {
            navCon.dismiss(animated: true)
        }
    }
    
    //MARK: - func showSortController
    func showSortController() {
        guard let navCon = navCon else { return }
        guard let firstView = navCon.viewControllers.first as? MainViewController else { return }
        firstView.sortViewController.modalPresentationStyle = .overCurrentContext
        navCon.present(firstView.sortViewController, animated: true)
    }
    
}
