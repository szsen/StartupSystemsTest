//
//  StoryImageViewController.swift
//  SocialStoryBuilder
//
//  Created by Sonia Sen on 11/12/15.
//  Copyright © 2015 Sonia Sen. All rights reserved.
//

import UIKit

class StoryImageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var captionLabel: UILabel!
    
    var pageImages: [UIImage] = []
    var pageCaptions: [String] = []
    var pageViews: [UIImageView?] = []
    
    var panels: JSON? // set by StoryCollectionView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self

        // 1
//        pageImages = [UIImage(named: "teddyrec.jpg")!,
//            UIImage(named: "teddymon.jpg")!,
//            UIImage(named: "teddylay.jpg")!,
//            UIImage(named: "teddylin.jpg")!,
//            UIImage(named: "teddycab.jpg")!]
//        
//        pageCaptions = ["Teddy at the recording studio",
//            "Teddy at the Washington Monument",
//            "Teddy laying down",
//            "Teddy at the Lincoln Memorial",
//            "Teddy with his cabin"]
        
        //Go through the panels to get the images and the captions
        for panel in panels! {
            //Get the image from URL
            var currImage = UIImage(named: "teddyrec.jpg")

            print("panel:", panel.1)
            if let url = NSURL(string: panel.1["url"].stringValue) {
           // if let url = NSURL(string: "https:\/\/upload.wikimedia.org\/wikipedia\/commons/c/c9/Wash_your_hands.svg")
                if let data = NSData(contentsOfURL: url) {
                    currImage = UIImage(data: data)
                }
            }
            pageImages.append(currImage!)
            
            
            //Get caption
            let currCaption = panel.1["caption"].stringValue
            pageCaptions.append(currCaption)
            
        }
        
        let pageCount = pageImages.count
        
        // 2
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        
        captionLabel.text = pageCaptions[0]
        
        // 3
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        // 4
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageImages.count),
            height: pagesScrollViewSize.height)
        
        // 5
        loadVisiblePages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // 1
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            // 2
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            // 3
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            // 4
            pageViews[page] = newPageView
        }
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        
        captionLabel.text = pageCaptions[page]
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
