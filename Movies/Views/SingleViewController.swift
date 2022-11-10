//
//  ViewController.swift
//  Movies
//
//  Created by Secrieru Andrei on 10.11.2022.
//

import UIKit
import Combine

class SingleViewController: UIViewController {
    
    //MARK: - Properties
    
    var viewModel: MovieViewModel = {
        let viewModel = MovieViewModel()
        return viewModel
    }()

    private var cancellables: Set<AnyCancellable> = []
    
    var image: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let title = UILabel()
        title.textAlignment = .center
        title.font = UIFont(name: "Avenir-Black", size: 32)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.adjustsFontSizeToFitWidth = true
        title.numberOfLines = 1
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
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewLayout()
        bindViewModel()
        forwardBtn.addTarget(self, action: #selector(forwardIsPressed), for: .touchUpInside)
        backBtn.addTarget(self, action: #selector(backIsPressed), for: .touchUpInside)
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageIsTapped)))
    }
}


//MARK: - Layout
typealias SingleViewControllerLayout = SingleViewController
extension SingleViewControllerLayout {
    func setUpViewLayout() {
        setUpTitleLayout()
        setUpImageLayout()
        setUpForwardBtnLayout()
        setUpBackBtnLayout()
    }
    
    func setUpTitleLayout() {
        self.view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            titleLabel.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.2)
        ])
    }
    
    func setUpImageLayout() {
        self.view.addSubview(image)
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            image.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -16),
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
}

//MARK: - Buttons Actions

typealias SingleViewControllerBtnActions = SingleViewController
extension SingleViewControllerBtnActions {
    @objc func forwardIsPressed () {
        if (viewModel.itemIndex >= 0 && viewModel.itemIndex < viewModel.movies.count-1) {
            viewModel.itemIndex += 1
            backBtn.isEnabled = true
            selectMovie(index: viewModel.itemIndex)
        }
    }
    
    @objc func backIsPressed () {
        if (viewModel.itemIndex >= 1 && viewModel.itemIndex < viewModel.movies.count) {
            viewModel.itemIndex -= 1
            forwardBtn.isEnabled = true
            selectMovie(index: viewModel.itemIndex)
        }
    }
    
    func disableButtons () {
        if viewModel.itemIndex == viewModel.movies.count - 1 {
            forwardBtn.isEnabled = false
            backBtn.isEnabled = true
        } else if viewModel.itemIndex == 0 {
            backBtn.isEnabled = false
            forwardBtn.isEnabled = true
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

        }.store(in: &cancellables)
        disableButtons()
    }
}

typealias SingleViewControllerChangeMovie = SingleViewController
extension SingleViewControllerChangeMovie {
    func selectMovie(index: Int) {
        animate(uiView: self.titleLabel, newValue: viewModel.movies[index].title!, options: .transitionCrossDissolve, duration: 0.5)
        disableButtons()
        animate(uiView: image, newValue: viewModel.movies[index].posterImage!, options: .transitionCrossDissolve, duration: 0.5)
        
    }
}

