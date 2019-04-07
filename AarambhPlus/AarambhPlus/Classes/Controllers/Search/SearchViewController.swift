//
//  SearchViewController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 13/02/19.
//  Copyright © 2019 Santosh Dev. All rights reserved.
//

import UIKit

final class SearchViewController: BaseViewController {
    
    @IBOutlet weak private var searchTextField: UITextField!
    @IBOutlet private var searchView: UIView!
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var navBarWidth: NSLayoutConstraint!
    
    private var searchResults = [MediaItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        searchViewSetup()
        searchTextField.delegate = self
        collectionView.register(UINib(nibName: "RowItemCell", bundle: nil) , forCellWithReuseIdentifier: "RowItemCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {[weak self] in
            self?.navigationController?.navigationBar.addSubview((self?.searchView)!)
            self?.navBarWidth.constant = windowWidth
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchView.removeFromSuperview()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchView.removeFromSuperview()
//        navigationController?.navigationBar.isHidden = false
    }

    class func controller() -> SearchViewController {
        return UIStoryboard(name: "HomeScreen", bundle: nil).instantiateViewController(withIdentifier: "\(SearchViewController.self)") as! SearchViewController
    }
    
    @IBAction func didTapBacButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSearchButton(_ sender: UIButton) {
        if let text = searchTextField.text?.trimmingCharacters(in: CharacterSet.whitespaces), !text.isEmpty {
            getConentForSearchedString(text)
        }
        
    }
    
    @IBAction func didTextChanged(_ sender: UITextField) {
        
    }
}

extension SearchViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RowItemCell", for: indexPath) as! RowItemCell
        cell.configureCell(dataSource: searchResults[indexPath.row])
        return cell
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 30)/2, height: 220)
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
        loadVideoPlayer(searchResults[indexPath.row])
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        var str = textField.text ?? ""
//        let textRange = Range(range, in: str)!
//        str = str.replacingCharacters(in: textRange, with: string)
//        let searchStr = str as String
//        let finalStr = searchStr.trimmingCharacters(in: CharacterSet.whitespaces)
////        getConentForSearchedString(finalStr)
//        return true
//    }
}

private extension SearchViewController {
    
//    func searchViewSetup() {
//        searchView.layer.cornerRadius = 10
//        searchView.layer.borderWidth = 2
//        searchView.layer.borderColor = #colorLiteral(red: 0.8649813795, green: 0.5759062337, blue: 0.05096345999, alpha: 0.1198558539)
//        searchView.layer.masksToBounds = true
//    }
 
    func getConentForSearchedString(_ str: String) {
//        print(str)
        CustomLoader.addLoaderOn(self.view, gradient: false)
        NetworkManager.getInfoForSearchedString(str) {[weak self] (result) in
            CustomLoader.removeLoaderFrom(self?.view)
            if let data = self?.parseError(result)?.data {
                self?.searchResults = data
                self?.collectionView.reloadData()
            }
        }
    }
    
    func loadVideoPlayer(_ model: MediaItem?) {
        guard let permLink = model?.getPermLink() else {
            showAlertView("Error!", message: "No permlink found.")
            return
        }
        let controller = VideoDetailController.controller(permLink)
        navigationController?.pushViewController(controller, animated: true)
    }
}
