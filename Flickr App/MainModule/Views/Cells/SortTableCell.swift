//
//  SortTableCell.swift
//  Flickr App
//
//  Created by user on 23.07.2023.
//

import UIKit

protocol SortTableCellDelegate: AnyObject {
    func cellDidSelect(index: Int)
}

final class SortTableCell: UITableViewCell {
    
    static let identifier = "SortTableCell"
    
    weak var delegate: SortTableCellDelegate?
    
    //MARK: - titleLabel
    let titleLabel: UILabel = {
        var lab = UILabel()
        lab.text = "Сортировка"
        lab.translatesAutoresizingMaskIntoConstraints = false
        lab.textColor = .white
        lab.textAlignment = .center
        
        return lab
    }()
    
    //MARK: - tapCellGesture
    private lazy var tapCellGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(tapCellAction))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = #colorLiteral(red: 0.6992026567, green: 0.6992026567, blue: 0.6992026567, alpha: 1)
        contentView.addGestureRecognizer(tapCellGesture)
        //MARK: - constraints titleLabel
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            titleLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
        
    }
    
    @objc func tapCellAction() {
        delegate?.cellDidSelect(index: titleLabel.tag)
    }
    
    //MARK: - config
    func config(text: String) {
        titleLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
