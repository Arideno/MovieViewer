//
//  MovieCell.swift
//  MovieViewer
//
//  Created by Andrii Moisol on 22.09.2020.
//

import UIKit
import SnapKit

class MovieCell: UICollectionViewCell {
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalToSuperview()
            make.center.equalTo(self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
