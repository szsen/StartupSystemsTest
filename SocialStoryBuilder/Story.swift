//
//  Story.swift
//  SocialStoryBuilder
//
//  Created by Sonia Sen on 11/15/15.
//  Copyright © 2015 Sonia Sen. All rights reserved.
//

import UIKit

class Story: NSObject {
    
    let title = NSString()
    var name = NSString()
    var storyInfo = NSDictionary()
    
    func initWithNSDictionary (jsonDictionary: NSDictionary){
        storyInfo = jsonDictionary
        name = storyInfo.valueForKey("name") as! NSString
    }
    
}
