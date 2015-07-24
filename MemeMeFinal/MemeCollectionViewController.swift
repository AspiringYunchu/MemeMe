//
//  MemeCollectionViewController.swift
//  ImagePicker
//
//  Created by yunchu on 7/13/15.
//  Copyright (c) 2015 AmerPe Studio. All rights reserved.
//

import UIKit
import Foundation

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    @IBOutlet weak var MemeCollectionView: UICollectionView!
    
    override func viewWillAppear(animated: Bool) {
        
        //refresh collection view
        super.viewWillAppear(animated)
        MemeCollectionView.reloadData()
    }
    
    override func viewDidLoad() {
        
        //set add meme button
        super.viewDidLoad()
        navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add"), animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return AppDelegate.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // set new cells for collection view
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let memeCollection = AppDelegate.memes[indexPath.row]
        
        // set the name and image
        
        cell.MemeCollectionImage.image = memeCollection.memedImage
        cell.MemeCollectionImage.contentMode = UIViewContentMode.ScaleToFill
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        // set detail view for collection meme cells
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.memeDetail = AppDelegate.memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
        
    }
    
    func add() {
        
        // set up segue to meme editor view
        var storyboard = UIStoryboard (name: "Main", bundle: nil)
        var editVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        // Communicate the match
        navigationController?.pushViewController(editVC, animated: true)
        tabBarController?.tabBar.hidden = true
    }

}
