//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Brian Ortega on 3/23/15.
//  Copyright (c) 2015 Brian Ortega. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet var memeTableView: UITableView!
    var memes: [Meme]! // will get memes array from app delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let applicationDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        memes = applicationDelegate.memes
        
        // Registers custom xib for table view cell
        let nib = UINib(nibName: "MemeTableViewCell", bundle: nil)
        self.memeTableView.registerNib(nib, forCellReuseIdentifier: "MemeTableCell")
        self.memeTableView.rowHeight = 66
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableCell") as MemeTableViewCell
        let meme = self.memes[indexPath.row]
        
        cell.memeTableCellImageView.image = meme.memedImage
        cell.memeTableCellLabel.text = "\(meme.topText) ... \(meme.bottomText)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
}
