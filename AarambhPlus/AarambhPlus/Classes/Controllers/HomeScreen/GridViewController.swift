//
//  GridViewController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/12/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

protocol GridViewProtocol {
    func fetchContent()
}

class GridViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel: JatraLandingScreenViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "RowItemCell", bundle: nil) , forCellWithReuseIdentifier: "RowItemCell")
        fetchJatraList()
    }
    
    class func controller() -> GridViewController {
        let vc =  UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "\(GridViewController.self)") as! GridViewController
        vc.viewModel = JatraLandingScreenViewModel()
        return vc
    }
    
}

extension GridViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowItemCell", for: indexPath) as! RowItemCell
        cell.configureCell(dataSource: viewModel?.jatras[indexPath.row])
        return cell
    }
    
}

extension GridViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (windowWidth - 30)/2, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (viewModel?.jatras.count ?? 0) - 1 {
            fetchJatraList()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        loadVideoPlayer(viewModel?.jatras[indexPath.row])
    }
}

private extension GridViewController {
    
    func fetchJatraList() {
        CustomLoader.addLoaderOn(view, gradient: false)
        viewModel?.fetchJatraList(limit: 10, completionHandler: {[weak self] (isSuccess,error) in
            CustomLoader.removeLoaderFrom(self?.view)
            if isSuccess {
                self?.collectionView.reloadData()
            } else {
                self?.showAlert(title: "Error!", message: error?.localizedDescription)
            }
        })
    }
    
    func loadVideoPlayer(_ model: Any?) {
        guard let permLink = (model as? MediaItem)?.getPermLink() else {
            showAlertView("Error!", message: "No permlink found.")
            return
        }
        let controller = VideoDetailController.controller(permLink)
        navigationController?.pushViewController(controller, animated: true)
    }
}
