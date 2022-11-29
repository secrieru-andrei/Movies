//
//  FavouriteViewController.swift
//  Movies
//
//  Created by Secrieru Andrei on 17.11.2022.
//

import UIKit
import Combine

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //MARK: - Properties
    
    var viewModel: MovieViewModel! {
        didSet {
            bindViewModel()
        }
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 200
        table.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "cellFavorites")
        table.backgroundColor = .clear
        return table
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        modifiers()
        setUpViewLayout()
        bindViewModel()
    }
}

//MARK: - Layout

typealias FavoritesViewControllerLayout = FavoritesViewController
extension FavoritesViewControllerLayout {
    func setUpViewLayout(){
        setUpTableViewLayout()
    }
    
    func setUpTableViewLayout(){
        self.view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - Modifiers

typealias FavoritesViewControllerViewModifiers = FavoritesViewController
extension FavoritesViewControllerViewModifiers {
    func modifiers() {
        bgModifiers()
    }
    
    func bgModifiers(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [
            UIColor.black.cgColor,
            UIColor(named: "darkRed")!.cgColor,
            UIColor.systemRed.cgColor,
        ]
        self.view.layer.addSublayer(gradientLayer)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}

//MARK: - Table View Data Control

typealias FavoritesControllerDataSource = FavoritesViewController
extension FavoritesControllerDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFavorites", for: indexPath) as! FavoritesTableViewCell
        let movie = viewModel.favoritesCellForRowAt(indexPath: indexPath)
        cell.setCell(movie: movie)
        cell.backgroundColor = UIColor(white: 0, alpha: 0.5)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.getNumberOfFavorites(section: 0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        viewModel.itemIndex = indexPath.row
        viewModel.itemId = viewModel.favorites[self.viewModel.itemIndex].id
        cellTapped()
    }
    
    func loadTableViewData() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }
    
    func removeCell(itemIndex: Int) {
        viewModel.removeFromFavorites(movie: viewModel.favorites[itemIndex])
    }    
}

//MARK: - Buttons Action

typealias FavoritesViewControllerBtnActions = FavoritesViewController
extension FavoritesViewControllerBtnActions {
    func cellTapped(){
        let newVc = ShowDetailsViewController()
        newVc.viewModel = self.viewModel
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(newVc, animated: false)
    }
}

//MARK: - ViewModel Bindings

typealias FavoritesViewControllerBindings = FavoritesViewController
extension FavoritesViewControllerBindings {
    func bindViewModel() {
        viewModel.$favorites.sink { [weak self] movie in
            self?.loadTableViewData()
        }.store(in: &cancellables)
    }
}

