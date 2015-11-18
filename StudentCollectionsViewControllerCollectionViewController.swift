//
//  StudentCollectionsViewControllerCollectionViewController.swift
//  SocialStoryBuilder
//
//  Created by Sonia Sen on 11/12/15.
//  Copyright © 2015 Sonia Sen. All rights reserved.
//

import UIKit

class StudentCollectionsViewControllerCollectionViewController: UICollectionViewController {

    private let reuseIdentifier = "StudentCell"
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 35.0, bottom: 50.0, right: 35.0)
    private var jsonData: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        

        // Do any additional setup after loading the view.
        
        let studentUrlString = "http://localhost:3000/api/students"
        let studentUrl = NSURL(string: studentUrlString)
        
        let urlSession = NSURLSession.sharedSession()
        urlSession.dataTaskWithURL(studentUrl!, completionHandler: { (data, response, error) -> Void in
            if (data?.length > 0 && error == nil){
                dispatch_async(dispatch_get_main_queue()) {
                        self.parseResponse(data!)
                    }
            }
            else if (data?.length == 0 && error == nil){
                print("Empty response")
            }
            else if (error != nil){
                print("there was an error", error)
            }
        }).resume()
        
        //TODO: finish populating arrays?
        
    }

    func parseResponse(responseData : NSData){
        
        jsonData = JSON(data: responseData)
        print("json data: ", jsonData![0])
        self.collectionView?.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if jsonData != nil{
            return jsonData!.count
        }
        else {
            return 1
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! StudentCollectionViewCell
    
        // Configure the cell
        
        cell.backgroundColor = UIColor.blackColor()
        if jsonData != nil {
            cell.nameLabel.text = jsonData![indexPath.row]["name"].stringValue
        }
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("selected something...")
        let storyCVC = self.storyboard!.instantiateViewControllerWithIdentifier("StoriesCollectionViewController") as! StoriesCollectionViewController
        if jsonData != nil {
            print(jsonData![indexPath.row]["name"])
            storyCVC.studentName = jsonData![indexPath.row]["name"].stringValue
        }
        
        self.navigationController?.pushViewController(storyCVC, animated: true)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */


//    func collectionView(collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAtIndexPath indexPath:NSIndexPath) -> CGSize
//    {
//        
//        return CGSizeMake(332, 316)
//    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }

}
