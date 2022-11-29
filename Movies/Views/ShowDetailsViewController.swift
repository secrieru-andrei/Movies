//
//  ShowDetailsViewController.swift
//  Movies
//
//  Created by Secrieru Andrei on 10.11.2022.
//

import UIKit
import Combine

class ShowDetailsViewController: UIViewController {
    
    //MARK: - Properties
    
    var viewModel: MovieViewModel! {
        didSet{
            bindViewModel()
        }
    }
    
    private var isInFavorites: Bool = false
    
    private var cancellables: Set<AnyCancellable> = []
    
    lazy var image: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: "Avenir-Light", size: 22 )
        label.textColor = .white
        return label
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.text = "Add to favorites"
        label.numberOfLines = 1
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Light", size: 22 )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var favButton: UIButton = {
        let btn = UIButton()
        let starImage = UIImage(systemName: "star")
        let starFilledImage = UIImage(systemName: "star.fill")
        btn.setImage(starImage, for: .normal)
        btn.tintColor = .systemYellow
        btn.setImage(starFilledImage, for: .highlighted)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modifiers()
        setUpViewLayout()
        favButton.addTarget(self, action: #selector(favButtonTapped), for: .touchUpInside)
    }
}

//MARK: - Layout

typealias ShowDetailsViewControllerLayout = ShowDetailsViewController
extension ShowDetailsViewControllerLayout {
    func setUpViewLayout() {
        setUpDescriptionLayout()
        setUpImageLayout()
        setUpLabelLayout()
        setUpFavoriteButton()
    }
    
    func setUpDescriptionLayout() {
        self.view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            descriptionLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
    }
    
    func setUpImageLayout() {
        view.addSubview(image)
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -16),
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            image.widthAnchor.constraint(equalTo: image.heightAnchor)
        ])
    }
    
    func setUpFavoriteButton() {
        view.addSubview(favButton)
        NSLayoutConstraint.activate([
            favButton.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
            favButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favButton.widthAnchor.constraint(equalToConstant: 50),
            favButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setUpLabelLayout() {
        view.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor , constant: 16),
            textLabel.widthAnchor.constraint(greaterThanOrEqualTo: view.widthAnchor, multiplier: 0.3),
            textLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
        ])
    }
}

//MARK: - Animations

typealias ShowDetailsViewControllerAnimations = ShowDetailsViewController
extension ShowDetailsViewControllerAnimations {
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

//MARK: - Binding

typealias ShowDetailsViewControllerBindings = ShowDetailsViewController
extension ShowDetailsViewControllerBindings {
    private func bindViewModel() {
        if let item = viewModel.movies.first(where: {$0.id == viewModel.itemId }) {
            self.isInFavorites = self.viewModel.checkMovieIsInFavorite(movie: item)
            favButtonState()
            animate(uiView: image, newValue: item.posterImage!, options: .transitionCrossDissolve, duration: 0.5)
            self.title = item.title
            animate(uiView: descriptionLabel, newValue: item.overview!, options: .transitionCrossDissolve, duration: 0.5)
        }
    }
}

//MARK: - Modifiers

typealias ShowDetailsViewControllerViewModifiers = ShowDetailsViewController
extension ShowDetailsViewControllerViewModifiers {
    func modifiers() {
        bgModifiers()
        favButtonState()
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
    
    func favButtonState() {
        if isInFavorites == true {
            favButton.isHighlighted = true
        } else {
            favButton.isHighlighted = false
        }
    }
}

//MARK: - Buttons Actions

typealias ShowDetailsViewControllerBtnActions = ShowDetailsViewController
extension ShowDetailsViewControllerBtnActions {
    @objc func favButtonTapped() {
        if isInFavorites == false{
            viewModel.favoritesCount += 1
            viewModel.saveToFavorites(movie: viewModel.movies[viewModel.itemIndex])
            DispatchQueue.main.async {
                self.favButton.isHighlighted = true
                self.isInFavorites = true
            }
        } else {
            let newVc = FavoritesViewController()
            viewModel.favoritesCount -= 1
            viewModel.removeFromFavorites(movie: viewModel.favorites[viewModel.itemIndex])
            newVc.viewModel = self.viewModel
            self.isInFavorites = false
        }
    }
}
    
