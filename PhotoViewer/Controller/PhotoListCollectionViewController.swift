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
    
    // cell identifiers
    private let reuseIdentifierAlbum    = "AlbumPhotoCell"
    private let reuseIdentifierPortrait = "PortraitPhotoCell"
    
    private var searchTerm = ""
    private var currentPage = 1
    private var totalPages = 1
    
    // array with search results
    private var searches: [SearchResults] = []
    
    // unsplash related
    private let unsplash = UnsplashClient()
    
    // cache
    var imagesCache = [String:UIImage]()
    
    var activityIndicator: UIActivityIndicatorView?
}


// MARK: - Private
private extension PhotoListCollectionViewController {
    func photo(for indexPath: IndexPath) -> UnsplashPhoto? {
        return searches[indexPath.section].searchResults?[indexPath.row]
    }
    
    func searchByTerm(string: String, andPageNum: Int) {
        // show activity indicator
        self.showActivityIndicator(show: true)
        
        // search for text
        unsplash.searchUnsplash(for: string, pageNumber: andPageNum) { searchResults in
            switch searchResults {
            case .error(let error) :
                self.showActivityIndicator(show: false)
                print("Error Searching: \(error)")
            case .results(let results):
                // save results and reload collection view
                self.searches.insert(results, at: self.searches.count)
                self.totalPages = results.totalPages
                self.searchTerm = string
                
                // update view
                self.collectionView?.reloadData()
                self.showActivityIndicator(show: false)
            }
        }
    }
    
    func showActivityIndicator(show: Bool) {
        if show {
            activityIndicator = UIActivityIndicatorView(style: .large)
            self.view.addSubview(activityIndicator!)
            activityIndicator?.hidesWhenStopped = true
            activityIndicator?.center = self.view.center
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
            activityIndicator?.removeFromSuperview()
        }
    }
    
    
    @objc func loadNextSearchItems() {
        // increment page number
        if self.currentPage < self.totalPages {
            self.currentPage += 1
            
            // load next page
            self.searchByTerm(string: self.searchTerm, andPageNum: self.currentPage)
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
        imagesCache.removeAll()
        
        // first page by default
        searchByTerm(string: textField.text!, andPageNum: currentPage)

        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
}



// MARK: - UICollectionViewDelegateFlowLayout
extension PhotoListCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // retrive unsplash photo
        if let unsplashPhoto = photo(for: indexPath) {
            // check if square or album shape
            if unsplashPhoto.width >= unsplashPhoto.height {
                return CGSize(width: 180, height: 120)
            } else {
                return CGSize(width: 120, height: 200)
            }
        }
        
        // default
        return CGSize(width: 200, height: 200)
    }
}


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
        // retrive unsplash photo
        guard let unsplashPhoto = photo(for: indexPath)
            else {
                return UICollectionViewCell()
        }
        
        // check if square or album shape
        let cellIdentifier = unsplashPhoto.width >= unsplashPhoto.height ? reuseIdentifierAlbum : reuseIdentifierPortrait
        
        // create cell with require identifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:cellIdentifier,
        for: indexPath) as! PhotoListCell
        
        // get image thumb url
        if let imageUrl = unsplashPhoto.unsplashThumbImageURL() {
            // check if image cached already
            if let cachedImage = imagesCache["\(unsplashPhoto.urls.thumb ?? "")"] {
                // use image from cache
                cell.imageView.image = cachedImage
            } else {
                // load and cache image from url
                cell.imageView.load(url: imageUrl) { (image) in
                    self.imagesCache[imageUrl.absoluteString] = image
                }
            }
                    
            let name = unsplashPhoto.user.name ?? "n/a"
            let desc = unsplashPhoto.description ?? ""
            cell.photoDescriptionLabel.text =  name + "\n" + desc
        }

        return cell
    }
}


// MARK: - UICollectionViewDelegate
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
        guard
            indexPath.section == searches.count - 1,
            indexPath.item == (searches[indexPath.section].searchResults?.count ?? 1) - 1
            else {
                return
        }

        // load more itrems
        loadNextSearchItems()
    }
}

