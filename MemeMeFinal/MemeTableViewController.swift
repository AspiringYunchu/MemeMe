//
//  MemeTableViewController.swift
//  ImagePicker
//
//  Created by yunchu on 7/9/15.
//  Copyright (c) 2015 AmerPe Studio. All rights reserved.
//

import UIKit

class MemeTableViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    // Outlet for table view
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        // create add new meme button
        super.viewDidLoad()
        navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add"), animated: true)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // refresh table view
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    func tableView(tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return number of memes as rows
        return AppDelegate.memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Set new cell for sent memes
        let memeCell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeCells
        let memeSingle = AppDelegate.memes[indexPath.row]
        
        // Set the name and image
        memeCell.labelMeme.text = memeSingle.topString + "..." + memeSingle.bottomString
        memeCell.labelMeme.textAlignment = .Center
        memeCell.imageViewMeme.image = memeSingle.memedImage
        
        return memeCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // set detail view for memes
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.memeDetail = AppDelegate.memes[indexPath.row]
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    func add() {
        
        // set segue to meme editor view
        var storyboard = UIStoryboard (name: "Main", bundle: nil)
        var editVC = storyboard.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        // Communicate the match
        navigationController?.pushViewController(editVC, animated: true)
        tabBarController?.tabBar.hidden = true
    }
}