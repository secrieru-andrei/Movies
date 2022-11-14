//
//  MovieTableViewCell.swift
//  Movies
//
//  Created by Secrieru Andrei on 11.11.2022.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    let cellIdentifier = "cell"
    var titleLabel: UILabel! = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.adjustsFontSizeToFitWidth = true
        title.font = UIFont(name: "Avenir-Black", size: 28)
        title.numberOfLines = 2
        title.textAlignment = .center
        title.textColor = .white
        return title
    }()
    
    var descriptionLabel: UILabel! = {
        let description = UILabel()
        description.translatesAutoresizingMaskIntoConstraints = false
        description.numberOfLines = 0
        description.adjustsFontSizeToFitWidth = true
        description.textAlignment = .justified
        description.font = UIFont(name: "Avenir-Light", size: 12 )
        description.textColor = .white
        return description
    }()
    
    var imageLabel: UIImageView! = {
        let img = UIImage(systemName: "car")
        let image = UIImageView(image: img)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(imageLabel)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        setImageLayout()
        setTitleLayout()
        setDescriptionLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Update Cell Data
    
    func setCell(movie: Movie){
        updateUI(title: movie.title, description: movie.overview, image: movie.posterImage)
    }
    
    func updateUI(title: String?, description: String?, image: String?){
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        guard let image = image else {return}
        self.imageLabel.loadImageFromURL(url: image)
    }
    
    //MARK: - Cell Layout
    
    func setCellLayout() {
        setImageLayout()
        setTitleLayout()
        setDescriptionLayout()
    }
    
    func setTitleLayout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: imageLabel.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2)
        ])
    }
    
    func setImageLayout() {
        NSLayoutConstraint.activate([
            imageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            imageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            imageLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4)
        ])
    }
    
    func setDescriptionLayout() {
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
}
