//
//  File.swift
//  ImagePicker
//
//  Created by yunchu on 7/4/15.
//  Copyright (c) 2015 AmerPe Studio. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    
    // basic properties of meme
    var topString: String
    var bottomString: String
    var originalImage: UIImage!
    var memedImage: UIImage!
    
    // initialize meme
    init (textTop: String, textBottom: String, image:
        UIImage, memedImage: UIImage) {
            
        topString = textTop
        bottomString = textBottom
        originalImage = image
        self.memedImage = memedImage
    }
    
    
}