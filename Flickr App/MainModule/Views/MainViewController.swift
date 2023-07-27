//
//  ViewController.swift
//  Flickr App
//
//  Created by user on 22.07.2023.
//

import UIKit
import Combine

//MARK: - tableState
enum TableState {
    case success, failure, initial
}

final class MainViewController: UIViewController {
    var viewModel: MainViewModelProtocol!
    var sortViewController: SortViewController!
    private var cancellable = Set<AnyCancellable>()
    
    //MARK: - tableView
    private lazy var tableView: UITableView = {
        var table = UITableView(frame: .zero, style: .plain)
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.backgroundColor = .white
        
        table.register(TableViewCell.self,
                       forCellReuseIdentifier: TableViewCell.identifier)
        
        table.delegate = self
        table.dataSource = self
        
        return table
    }()
    
    //обновление таблицы
    private var tableState: TableState = .initial {
        didSet {
            switch tableState {
            case .success:
                tableView.reloadData()
            case .failure:
                present(createErrorAlert(), animated: true)
            case .initial:
                print("tableView init")
            }
        }
    }
    
    //MARK: - searchBar
    private var searchBar: UISearchBar = {
        var bar = UISearchBar()
        bar.barStyle = .black
        bar.placeholder = "Поиск"
        
        return bar
    }()
    
    //MARK: - cancelButton
    private var cancelButton: UIButton = {
        var but = UIButton()
        but.setTitle("Отменить", for: .normal)
        but.setTitleColor(.black, for: .normal)
        but.backgroundColor = .white
        
        return but
    }()
    
    //MARK: - editorButton
    private var editorButton: UIButton = {
        var but = UIButton()
        but.backgroundColor = #colorLiteral(red: 0.6992026567, green: 0.6992026567, blue: 0.6992026567, alpha: 1)
        but.setImage(UIImage(systemName: "arrow.up.arrow.down"), for: .normal)
        but.tintColor = .white
        but.layer.cornerRadius = 10
        
        return but
    }()
    
    //MARK: - updateTableState
    private func updateTableState() {
        viewModel.updateTableState.sink { [unowned self] state in
            self.tableState = state
        }.store(in: &cancellable)
    }
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        sortViewController.delegate = self
        sortViewController.dataSource = self
        
        updateTableState()
        viewModel.fetchFlicer()
        constraintsTable()
        setNavigationBar()
    }
    
    //MARK: - constraints for table
    private func constraintsTable() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.topAnchor),
            
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor),
            
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - setNavigationBar
    private func setNavigationBar() {
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let view = UIView()
        view.frame = CGRect(x: .zero, y: .zero, width: self.view.frame.width, height: 44)
        view.clipsToBounds = true
        
        self.searchBar.frame = CGRect(x: .zero, y: .zero, width: self.view.frame.width/1.27, height: 44)
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonAction(sender:)), for: .touchUpInside)
        cancelButton.frame = CGRect(x: self.view.frame.width/1.1 + 10, y: .zero, width: 200, height: 30)
        
        editorButton.frame = CGRect(x: self.view.frame.width - 76, y: 4, width: 36, height: 36)
        
        editorButton.addTarget(self, action: #selector(editorTap), for: .touchUpInside)
        
        view.addSubview(editorButton)
        view.addSubview(cancelButton)
        
        navigationItem.titleView = view
    }
    
    //MARK: - createErrorAlert
    private func createErrorAlert() -> UIAlertController {
        let errorAlert = UIAlertController(title: "Ошибка!", message: "Возникла ошибка при подключении к серверу", preferredStyle: .alert)
        let errorAction = UIAlertAction(title: "Попробовать снова", style: .default) { [unowned self] _ in
            self.viewModel.fetchFlicer()
        }
        errorAlert.addAction(errorAction)
        
        return errorAlert
    }
    
    //MARK: - cancelButtonAction
    @objc private func cancelButtonAction(sender: UIButton) {
        searchBar.endEditing(true)
    }
    
    //MARK: - editorTap
    @objc private func editorTap() {
        viewModel.showSortController()
    }
    
}

//MARK: - extension
extension MainViewController: UITableViewDelegate,
                              UITableViewDataSource,
                              TableViewCellDelegate,
                              UISearchBarDelegate,
                              SortViewControllerDelegate,
                              SortViewControllerDataSource {
    func numberOfRows() -> Int {
        return viewModel.sortDescription.count
    }
    
    //MARK: - SortViewControllerDataSource
    func textForCell(indexPath: IndexPath) -> String {
        return viewModel.sortDescription[indexPath.row]
    }
    
    //MARK: - SortViewControllerDelegate
    func cellWasSelect(index: Int) {
        viewModel.sortArray(index: index)
    }
    
    //MARK: - TableViewCellDelegate
    func imageWasTaped(tag: Int) {
        self.viewModel.showPhotoController(index: tag)
    }
    
    //MARK: - searchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5) {
            self.editorButton.frame = CGRect(x: self.view.frame.width, y: 4, width: 36, height: 36)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [unowned self] in
            UIView.animate(withDuration: 0.5) {
                searchBar.frame = CGRect(x: .zero, y: .zero,
                                         width: self.view.frame.width/1.55,
                                         height: 44)
                self.cancelButton.frame = CGRect(x: self.view.frame.width/1.55 + 6,
                                                 y: .zero, width: 100, height: 44)
            }
        })
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        UIView.animate(withDuration: 0.5) {
            searchBar.frame = CGRect(x: .zero, y: .zero,
                                     width: self.view.frame.width/1.25, height: 44)
            self.cancelButton.frame = CGRect(x: self.view.frame.width/1.1 + 10,
                                             y: .zero, width: 200, height: 44)
            
            self.editorButton.frame = CGRect(x: self.view.frame.width - 70, y: 4, width: 36, height: 36)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        viewModel.searchText = text
        viewModel.fetchFlicer()
        
        searchBar.resignFirstResponder()
    }
    
    //MARK: - tableViewDelegate, DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.flickrInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell {
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            
            cell.tapImage.view?.tag = indexPath.row
            cell.configurate(imageData: viewModel.imagesData[indexPath.row],
                             title: viewModel.flickrInfo[indexPath.row].photo.title.content,
                             teg: viewModel.returnTegs(index: indexPath.row))
            cell.delegate = self
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Отступы внутри ячейки
        let padding = CGFloat(10)
        let font = UIFont.systemFont(ofSize: 18)
        let image = CGFloat(250)
        
        if viewModel.imagesData.isEmpty {
            return view.frame.height/2.5
        } else {
            let width = tableView.frame.width - padding * 2    // ширина строки таблицы
            let text = viewModel.flickrInfo[indexPath.row].photo.title.content
            let tegs = viewModel.returnTegs(index: indexPath.row)
            let size = CGSize(width: width, height: .infinity)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedHeight = NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil).height

            let estimatedHeightTegs = NSString(string: tegs).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: font], context: nil).height

            return estimatedHeight + padding * 2 + image + estimatedHeightTegs
        }
    }
}

