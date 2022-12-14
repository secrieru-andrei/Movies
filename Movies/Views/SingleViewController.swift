//
//  ViewController.swift
//  Movies
//
//  Created by Secrieru Andrei on 10.11.2022.
//

import UIKit
import Combine

class SingleViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Properties
    
    var viewModel: MovieViewModel = {
        let viewModel = MovieViewModel()
        return viewModel
    }()
    
    var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        return switchControl
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    
    var image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 5.0
        imageView.layer.shadowOpacity = 1.0
        imageView.layer.shadowOffset = CGSize(width: 3, height: 3)
        imageView.layer.masksToBounds = false
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = UIFont(name: "Avenir-Black", size: 32)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 1
        title.textColor = .white
        return title
    }()
    
    var forwardBtn: UIButton = {
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Forward", attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Black", size: 18) ?? ""]), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Forward", attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Black", size: 18) ?? ""]), for: .selected)
        
        return button
    }()
    
    var backBtn: UIButton = {
        let button = UIButton(configuration: .filled())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Black", size: 18) ?? ""]), for: .normal)
        button.setAttributedTitle(NSAttributedString(string: "Back", attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Black", size: 18) ?? ""]), for: .selected)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.rowHeight = 200
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        table.backgroundColor = .clear
        return table
    }()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        self.navigationController?.navigationBar.tintColor = UIColor.white
        modifiers()
        setUpNavBar()
        setUpViewLayout()
        bindViewModel()
        forwardBtn.addTarget(self, action: #selector(forwardIsPressed), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backIsPressed), for: .touchUpInside)
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageIsTapped)))
        switchControl.addTarget(self, action: #selector(switchTapped), for: .valueChanged)
        self.view.isUserInteractionEnabled = true
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(forwardIsPressed))
        leftSwipe.direction = .left
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backIsPressed))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        self.view.addGestureRecognizer(leftSwipe)
    }
}

//MARK: - Layout
typealias SingleViewControllerLayout = SingleViewController
extension SingleViewControllerLayout {
    func setUpViewLayout() {
        setUpImageLayout()
        setUpTitleLayout()
        setUpForwardBtnLayout()
        setUpBackBtnLayout()
        setUpTableViewLayout()
    }
    
    func setUpTitleLayout() {
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            titleLabel.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.2)
        ])
    }
    
    func setUpImageLayout() {
        self.view.addSubview(image)
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            image.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            image.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
    }
    
    func setUpForwardBtnLayout() {
        self.view.addSubview(forwardBtn)
        NSLayoutConstraint.activate([
            forwardBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            forwardBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            forwardBtn.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setUpBackBtnLayout() {
        self.view.addSubview(backBtn)
        NSLayoutConstraint.activate([
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backBtn.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setUpNavBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: switchControl)
        navigationItem.title = "Movies"
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

//MARK: - Buttons Actions

typealias SingleViewControllerBtnActions = SingleViewController
extension SingleViewControllerBtnActions {
    @objc func forwardIsPressed () {
        if (viewModel.itemIndex >= 0 && viewModel.itemIndex < viewModel.movies.count-1) {
            viewModel.itemIndex += 1
            backBtn.isHidden = false
            selectMovie(index: viewModel.itemIndex)
        }
    }
    
    @objc func backIsPressed () {
        if (viewModel.itemIndex >= 1 && viewModel.itemIndex < viewModel.movies.count) {
            viewModel.itemIndex -= 1
            forwardBtn.isHidden = false
            selectMovie(index: viewModel.itemIndex)
        }
    }
    
    func disableButtons () {
        if viewModel.itemIndex == viewModel.movies.count - 1 {
            forwardBtn.isHidden = true
            backBtn.isHidden = false
        } else if viewModel.itemIndex == 0 {
            backBtn.isHidden = true
            forwardBtn.isHidden = false
        }
    }
    
    @objc func imageIsTapped(){
        let newVc = ShowDetailsViewController()
        newVc.viewModel = self.viewModel
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        navigationController?.view.layer.add(transition, forKey: nil)
        navigationController?.pushViewController(newVc, animated: false)
    }
    
    @objc func switchTapped() {
        let value: Bool = switchControl.isOn
        showView(value: value)
    }
}

//MARK: - Animations

typealias SingleViewControllerAnimation = SingleViewController
extension SingleViewControllerAnimation {
    func animate(uiView: UIView, newValue: String, options: UIView.AnimationOptions, duration: CFTimeInterval) {
        UIView.transition(with: uiView,
                          duration: duration,
                          options: options) {
            if let imageView = uiView as? UIImageView {
                imageView.loadImageFromURL(url: newValue)
            } else if let label = uiView as? UILabel {
                label.text = newValue
            }
        }
    }
}

//MARK: - ViewModel Bindings

typealias SingleViewControllerBindings = SingleViewController
extension SingleViewControllerBindings {
    func bindViewModel() {
        viewModel.$movies.sink { [weak self] movie in
            self?.titleLabel.text = movie.first?.title
            guard let imageUrl = movie.first?.posterImage else {return}
            self?.image.loadImageFromURL(url: imageUrl)
            self?.viewModel.moviesCount = movie.count
            self?.loadTableViewData()
        }.store(in: &cancellables)
        disableButtons()
    }
}

//MARK: - Change Movie

typealias SingleViewControllerChangeMovie = SingleViewController
extension SingleViewControllerChangeMovie {
    func selectMovie(index: Int) {
        animate(uiView: self.titleLabel, newValue: viewModel.movies[index].title!, options: .transitionCrossDissolve, duration: 0.5)
        disableButtons()
        animate(uiView: image, newValue: viewModel.movies[index].posterImage!, options: .transitionCrossDissolve, duration: 0.5)
    }
}

//MARK: - TableView Data Source

typealias TableViewControllerDataSource = SingleViewController
extension TableViewControllerDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MovieTableViewCell
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
        cell.setCell(movie: movie)
        cell.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.moviesCount
    }
    
    func loadTableViewData() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.itemIndex = indexPath.row
        imageIsTapped()
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Movies"
//    }
}

//MARK: Show/Hide Views

typealias SingleViewControllerShowOrHideView = SingleViewController
extension SingleViewControllerShowOrHideView {
    func showView(value: Bool){
        self.titleLabel.isHidden = value
        self.image.isHidden = value
        self.forwardBtn.isHidden = value
        self.backBtn.isHidden = value
        self.tableView.isHidden = !value
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        self.view.layer.add(transition, forKey: nil)
    }
}

//MARK: - Modifiers

typealias SingleViewControllerViewModifiers = SingleViewController
extension SingleViewControllerViewModifiers {
    func modifiers() {
        backgroundgModifiers()
        buttonsModifiers()
        tableViewModifiers()
    }
    
    func backgroundgModifiers(){
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
    
    func buttonsModifiers () {
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowRadius = 2
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowOffset = CGSize(width: 3, height: 3)
        
    }
    
    func tableViewModifiers () {
        
    }
    
}

