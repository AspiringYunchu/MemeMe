//
//  MemeDetailViewController.swift
//  ImagePicker
//
//  Created by yunchu on 7/13/15.
//  Copyright (c) 2015 AmerPe Studio. All rights reserved.
//

import UIKit
import Foundation

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var MemeDetailImage: UIImageView!
    
    var memeDetail: Meme!
    
    override func viewWillAppear(animated: Bool) {
        
        //set meme detail view
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = true
        MemeDetailImage.image = memeDetail.memedImage
        MemeDetailImage.contentMode = UIViewContentMode.ScaleAspectFit
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
}
