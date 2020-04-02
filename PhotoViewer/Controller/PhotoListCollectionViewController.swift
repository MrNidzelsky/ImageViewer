//
//  PhotoListCollectionViewController.swift
//  PhotoViewer
//
//  Created by Dmitry  Nidzelsky  on 3/28/20.
//  Copyright © 2020 Dmitry  Nidzelsky . All rights reserved.
//

import Foundation
import UIKit


protocol PhotoListCollectionVCProtocol: AnyObject {
    var unsplash: UnsplashAPIProtocol { get }
    var searches: [SearchResults] { get set }
}

final class PhotoListCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "PhotoCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0,
                                             left: 20.0,
                                             bottom: 50.0,
                                             right: 20.0)
    
    // array with search results
    private var searches: [SearchResults] = []
    
    // unsplash related
    private let unsplash = UnsplashClient()
    
    private var searchTerm = ""
    private var currentPage = 1
    private var totalPages = 1
}


// MARK: - Private
private extension PhotoListCollectionViewController {
    func photo(for indexPath: IndexPath) -> UnsplashPhoto? {
        return searches[indexPath.section].searchResults?[indexPath.row]
    }
    
    func searchByTerm(string: String, andPageNum: Int) {
        print("searchByTerm : \(string) andPageNum \(andPageNum)")
        // search for text
        unsplash.searchUnsplash(for: string, pageNumber: andPageNum) { searchResults in
            switch searchResults {
            case .error(let error) :
                print("Error Searching: \(error)")
            case .results(let results):
                print("Found \(String(describing: results.searchResults?.count)) matching \(self.searchTerm)")
                
                // save results and reload collection view
                self.searches.insert(results, at: self.searches.count)
                self.totalPages = results.totalPages
                self.searchTerm = string
                
                // update view
                self.collectionView?.reloadData()
            }
        }
    }
    
    
    @objc func loadNextSearchItems() {
        if self.currentPage < self.totalPages {
            // increment page number
            if self.currentPage < self.totalPages {
                self.currentPage += 1
                
                // load next page
                self.searchByTerm(string: self.searchTerm, andPageNum: self.currentPage)
            }
        }
    }
}


// MARK: - Text Field Delegate
extension PhotoListCollectionViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // clear search related values
        searchTerm  = ""
        currentPage = 1
        totalPages  = 1
        searches.removeAll()
        
        // first page by default
        searchByTerm(string: textField.text!, andPageNum: currentPage)

        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}


/*
// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // retrive unsplash photo
        let unsplashPhoto = photo(for: indexPath)
        
        return CGSize(width: unsplashPhoto.width, height: unsplashPhoto.height)
    }
}
 */



// MARK: - UICollectionViewDataSource
extension PhotoListCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return searches.count
    }
  
    
    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return searches[section].searchResults?.count ?? 0
    }
  
  
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:reuseIdentifier,
                                                      for: indexPath) as! PhotoListCell
    
        // TODO: replace
        // retrive unsplash photo
        let unsplashPhoto = photo(for: indexPath)
    
        if let imageUrl = unsplashPhoto?.unsplashThumbImageURL() {
            cell.imageView.load(url: imageUrl)
            
            let name = unsplashPhoto?.user.name ?? "n/a"
            let desc = unsplashPhoto?.description ?? ""
            
            cell.photoDescriptionLabel.text =  name + "\n" + desc
        }

        return cell
    }
}


// MARK: - UICollectionView Delegate
extension PhotoListCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // show details controller
        let detailsController = UIStoryboard(name: "Main", bundle:nil).instantiateViewController(withIdentifier:"PhotoDetailsViewController") as! PhotoDetailsViewController
        
        // retrive unsplash photo
        guard let unsplashPhoto = photo(for: indexPath) else { return  }
        detailsController.initWithPhoto(unsplashPhoto)
        
        self.navigationController?.pushViewController(detailsController, animated: true)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == (searches[indexPath.section].searchResults?.count ?? 1) - 1 {
            loadNextSearchItems()
        }
    }
}

// TODO: replace to separate Extension file
extension UIImageView {
    
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
    
    func makeRounded() {
        self.layer.borderWidth = 8
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
}
