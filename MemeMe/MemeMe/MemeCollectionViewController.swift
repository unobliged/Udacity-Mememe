//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Brian Ortega on 3/23/15.
//  Copyright (c) 2015 Brian Ortega. All rights reserved.
//

import Foundation
import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    var memes: [Meme]! // will get memes array from app delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let applicationDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        memes = applicationDelegate.memes
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeGridCell", forIndexPath: indexPath) as MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        cell.memeCellImageView.image = meme.memedImage
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
