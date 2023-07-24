//
//  TableViewCell.swift
//  Flickr App
//
//  Created by user on 22.07.2023.
//

import UIKit

protocol TableViewCellDelegate: AnyObject {
    func imageWasTaped(tag: Int)
}

final class TableViewCell: UITableViewCell {
    
    static let identifier = "TableCell"
    weak var delegate: TableViewCellDelegate?

    
    //MARK: - photoImageView
    private let photoImageView: UIImageView = {
        var img = UIImageView(frame: .zero)
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .red
        img.isUserInteractionEnabled = true
        img.contentMode = .scaleToFill
        
        return img
    }()
    
    //MARK: - titleLabel
    let titleLabel: UILabel = {
        var lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textAlignment = .left
        lab.textColor = .black
        lab.numberOfLines = 0
        lab.lineBreakMode = .byWordWrapping
        
        return lab
    }()
    
    //MARK: - tegsLabel
    private let tegsLabel: UILabel = {
        var lab = UILabel()
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textAlignment = .left
        lab.textColor = .blue
        lab.numberOfLines = 0
        lab.lineBreakMode = .byWordWrapping
        
        return lab
    }()
    
    //MARK: - tapImage
    lazy var tapImage = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        //MARK: - photoImageView constraints
        contentView.addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.heightAnchor.constraint(equalToConstant: 240)
        ])
        photoImageView.addGestureRecognizer(tapImage)
        
        //MARK: - titleLabel constraints
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 2),
            titleLabel.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -2),
        ])
        
        //MARK: - tegsLabel constraints
        contentView.addSubview(tegsLabel)
        NSLayoutConstraint.activate([
            tegsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            tegsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tegsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
    }
    
    //MARK: - tapAction
    @objc func tapAction(sender: UITapGestureRecognizer) {
        self.delegate?.imageWasTaped(tag: sender.view?.tag ?? 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configurate
    func configurate(imageData: Data, title: String, teg: String) {
        photoImageView.image = UIImage(data: imageData)
        titleLabel.text = title
        tegsLabel.text = teg
    }
    
}
