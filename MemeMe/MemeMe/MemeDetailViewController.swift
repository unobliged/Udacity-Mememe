//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Brian Ortega on 3/25/15.
//  Copyright (c) 2015 Brian Ortega. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme! // this will get passed by either table or collection view controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView!.image = meme.memedImage
    }

}
