//
//  FavoriteViewController.swift
//  MovieViewer
//
//  Created by Andrii Moisol on 22.09.2020.
//

import UIKit

class FavoriteViewController: UIViewController {
    
    let presenter: FavoriteMoviesPresenter
    var collectionView: UICollectionView!
    
    let networkManager = NetworkManager()
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refreshMovies), for: .valueChanged)
        return refresh
    }()
    
    init(with presenter: FavoriteMoviesPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        title = "MovieViewer"
        
        networkManager.delegate = self
        
        setupCollectionView()
        
        getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMovies()
    }
    
    func getMovies() {
        presenter.getMovies(page: 1) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let width = self.view.frame.size.width / 3 - 20
        layout.itemSize = CGSize(width: width, height: width * 1.5)
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = presenter
        collectionView.refreshControl = refreshControl
        presenter.registerCells(for: collectionView)
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    @objc func refreshMovies() {
        presenter.getMovies(page: 1) { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard collectionView != nil else { return }
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        coordinator.animate { (context) in
            if UIDevice.current.orientation.isLandscape {
                let width = size.width / 5 - 40
                flowLayout.itemSize = CGSize(width: width, height: width * 1.5)
            } else {
                let width = size.width / 3 - 20
                flowLayout.itemSize = CGSize(width: width, height: width * 1.5)
            }
            flowLayout.invalidateLayout()
        }
    }
}

extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = presenter.getMovieByIndex(indexPath.item)
        let detailViewController = DetailViewController()
        detailViewController.presenter.setMovie(movie: movie)
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension FavoriteViewController: NetworkManagerProtocol {
    func networkStatusChanged(satisfied: Bool) {
        if (satisfied) {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        } else {
            let alertController = UIAlertController(title: "No connection", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
            }))
            present(alertController, animated: true, completion: nil)
        }
    }
}
