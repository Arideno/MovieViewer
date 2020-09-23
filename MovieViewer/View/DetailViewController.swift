//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Andrii Moisol on 22.09.2020.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    let presenter = DetailPresenter()
    
    lazy var imageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFill
        im.kf.setImage(with: URL(string: IMAGES_URL + presenter.backdrop))
        im.kf.indicatorType = .activity
        return im
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = presenter.title
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.text = presenter.overview
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    lazy var releaseLabel: UILabel = {
        let label = UILabel()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: presenter.releaseDate)!
        dateFormatter.dateFormat = "dd.MM.yyyy"
        label.text = "Release Date: \(dateFormatter.string(from: date))"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let btn = UIButton()
        if presenter.favorite {
            btn.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            btn.setImage(UIImage(systemName: "star"), for: .normal)
        }
        btn.tintColor = .white
        btn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onFavorite)))
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        title = presenter.title
        
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(releaseLabel)
        view.addSubview(favoriteButton)
        
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.height.equalTo(250)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        overviewLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
        }
        
        releaseLabel.snp.makeConstraints { (make) in
            make.top.equalTo(overviewLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(10)
        }
        
        favoriteButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(releaseLabel.snp.centerY)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-10)
            make.width.height.equalTo(50)
        }
    }
    
    @objc func onFavorite() {
        presenter.toggleFavorite(completion: { favorite in
            DispatchQueue.main.async {
                if favorite {
                    self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                } else {
                    self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                }
            }
        })
    }

}
