//
//  PhotoViewController.swift
//  Flickr App
//
//  Created by user on 22.07.2023.
//

import UIKit

final class PhotoViewController: UIViewController {
    
    var viewModel: PhotoViewModelProtocol!
    
    //MARK: - scrollView
    private lazy var scrollView: UIScrollView = {
        var scrl = UIScrollView()
        scrl.translatesAutoresizingMaskIntoConstraints = false
        scrl.showsHorizontalScrollIndicator = false
        scrl.showsVerticalScrollIndicator = false
        scrl.backgroundColor = .white
        scrl.delegate = self
        scrl.minimumZoomScale = 1.0
        scrl.maximumZoomScale = 4.0
        
        return scrl
    }()
    
    private lazy var imageView: UIImageView = {
        var img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.image = UIImage(data: viewModel.imageData)
        img.isUserInteractionEnabled = true
        
        return img
    }()
    
    private lazy var closeButton: UIButton = {
        var but = UIButton(type: .system)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.setTitle("Закрыть", for: .normal)
        but.setTitleColor(.black, for: .normal)
        but.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        but.titleLabel?.font = .systemFont(ofSize: 20)
        but.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
        but.layer.cornerRadius = 10
        
        return but
    }()
    
    private lazy var tapImage = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
    
    override func viewDidLoad() {
        super .viewDidLoad()
        view.backgroundColor = .white
        setConstraints()
    }
    
    //MARK: - setConstraints
    func setConstraints() {
        //MARK: - scrollView constraints
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: view.frame.height/2)
        ])
        
        //MARK: - imageView constraints
        scrollView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height/2),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
        self.imageView.addGestureRecognizer(tapImage)
        
        //MARK: - closeButton constraints
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            closeButton.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -96),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    //MARK: - tapAction
    @objc func tapAction(sender: UITapGestureRecognizer) {
        scrollView.setZoomScale(1, animated: true)
    }
    
    //MARK: - tapClose
    @objc private func tapClose() {
        viewModel.closePhotoViewController()
    }
    
}
extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        self.imageView
    }
}
