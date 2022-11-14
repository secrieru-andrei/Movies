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
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modifiers()
        setUpViewLayout()
    }
}

//MARK: - Layout

typealias ShowDetailsViewControllerLayout = ShowDetailsViewController
extension ShowDetailsViewControllerLayout {
    func setUpViewLayout() {
        setUpDescriptionLayout()
        setUpImageLayout()
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

typealias ShowDetailsViewControllerBindings = ShowDetailsViewController
extension ShowDetailsViewControllerBindings {
    private func bindViewModel() {
        let movie = viewModel.movies[viewModel.itemIndex]
        animate(uiView: image, newValue: movie.posterImage!, options: .transitionCrossDissolve, duration: 0.5)
        self.title = movie.title
        animate(uiView: descriptionLabel, newValue: movie.overview!, options: .transitionCrossDissolve, duration: 0.5)
    }
}

//MARK: - Modifiers

typealias ShowDetailsViewControllerViewModifiers = ShowDetailsViewController
extension ShowDetailsViewControllerViewModifiers {
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
    
    
