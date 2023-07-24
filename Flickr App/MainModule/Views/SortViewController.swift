//
//  SortViewController.swift
//  Flickr App
//
//  Created by user on 23.07.2023.
//

import UIKit

protocol SortViewControllerDataSource: AnyObject {
    func textForCell(indexPath: IndexPath) -> String
    func numberOfRows() -> Int
}

protocol SortViewControllerDelegate: AnyObject {
    func cellWasSelect(index: Int)
}

final class SortViewController: UIViewController {
    
    weak var delegate: SortViewControllerDelegate?
    weak var dataSource: SortViewControllerDataSource?
    
    //MARK: - tableView
    private lazy var tableView: UITableView = {
        var table = UITableView(frame: .zero, style: .insetGrouped)
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isScrollEnabled = false
        table.backgroundColor = .clear
        
        table.register(SortTableCell.self,
                       forCellReuseIdentifier: SortTableCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    private lazy var closeButton: UIButton = {
        var but = UIButton(type: .system)
        but.setTitle("Отмена", for: .normal)
        but.translatesAutoresizingMaskIntoConstraints = false
        but.titleLabel?.font = .boldSystemFont(ofSize: 20)
        but.backgroundColor = #colorLiteral(red: 0.6992026567, green: 0.6992026567, blue: 0.6992026567, alpha: 1)
        but.tintColor = .white
        but.layer.cornerRadius = 10
        but.addTarget(self, action: #selector(tapActionButton), for: .touchUpInside)
        
        return but
    }()
    
    //MARK: - mainView
    private var mainView: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    //tapGesture
    private lazy var tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super .viewDidLoad()
        setConstraints()
    }
    
    //MARK: - setConstraints
    private func setConstraints() {
        view.addGestureRecognizer(tapGesture)
        //MARK: - constraints mainView
        view.addSubview(mainView)
        
        NSLayoutConstraint.activate([
            mainView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -360),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mainView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        //MARK: - constraints tableView
        mainView.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: mainView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor)
        ])
        
        //MARK: - constraints closeButton
        mainView.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -20),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            closeButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    //MARK: - tapActionButton
    @objc func tapActionButton() {
        dismiss(animated: true)
    }
    
    //MARK: - tapAction
    @objc func tapAction(sender: UITapGestureRecognizer) {
        let possition = sender.location(in: self.view)
        if (possition.y > mainView.frame.maxY - 90 || possition.y < mainView.frame.minY + 40) || (possition.x > mainView.frame.maxX - 20 || possition.x < mainView.frame.minX + 20) {
            dismiss(animated: true)
        }
    }

}

extension SortViewController: UITableViewDelegate,
                              UITableViewDataSource,
                              SortTableCellDelegate {
    
    //sortTableDelegate
    func cellDidSelect(index: Int) {
        delegate?.cellWasSelect(index: index)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SortTableCell.identifier) as? SortTableCell {
            
            //отключение нажатий в 1 яйчейке
            if indexPath.row == 0 {
                cell.isUserInteractionEnabled = false
                cell.titleLabel.tag = indexPath.row
            } else {
                cell.titleLabel.font = .systemFont(ofSize: 20)
            }
            cell.titleLabel.tag = indexPath.row
            cell.config(text: dataSource?.textForCell(indexPath: indexPath) ?? "")
            cell.delegate = self
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 30
        default:
            return 50
        }
    }
    
}
