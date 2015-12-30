//
//  ContainerViewController.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015 naoto yamaguchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

class ContainerViewController: UIViewController, SwipePagerDataSource, SwipePagerDelegate {
    
    // MARK: - Property
    
    var ORIGIN_Y: CGFloat = CGRectGetHeight(UIApplication.sharedApplication().statusBarFrame)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sample"
        
        if let height = self.navigationController?.navigationBar.frame.height {
            ORIGIN_Y += height
        }
        
        let frame = CGRectMake(
            0,
            ORIGIN_Y,
            CGRectGetWidth(self.view.frame),
            CGRectGetHeight(self.view.frame) - ORIGIN_Y
        )
        
        let swipePager = SwipePager(frame: frame, transitionStyle: .Scroll)
        swipePager.dataSource = self
        swipePager.delegate = self
        self.view.addSubview(swipePager)
        swipePager.reloadData()

		swipePager.selectViewControllerAtIndex(5)

		let delay = 1 * Double(NSEC_PER_SEC)
		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
		dispatch_after(delayTime, dispatch_get_main_queue()) {
			swipePager.selectViewControllerAtIndex(Int(arc4random_uniform(8)), animated: true)
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - SwipePagerDataSource
    
    func sizeForMenu(swipePager: SwipePager) -> CGSize {
        return CGSizeMake(80, 50)
    }
    
    func menuViews(swipePager: SwipePager) -> [SwipePagerMenu] {
        var array: [SwipePagerMenu] = []
        
        for var i = 0; i < 8; i++ {
            let menu = SwipePagerMenu()
            menu.stateNormalColor = UIColor.lightGrayColor()
            menu.stateNormalFontColor = UIColor.whiteColor()
            menu.stateHighlightColor = UIColor.blackColor()
            menu.stateHighlightFontColor = UIColor.whiteColor()
            if i == 0 { menu.title = "0" }
            if i == 1 { menu.title = "1" }
            if i == 2 { menu.title = "2" }
            if i == 3 { menu.title = "3" }
            if i == 4 { menu.title = "4" }
            if i == 5 { menu.title = "5" }
            if i == 6 { menu.title = "6" }
            if i == 7 { menu.title = "7" }
            array.append(menu)
        }
        
        return array
    }
    
    func viewControllers(swipePager: SwipePager) -> [UIViewController] {
        var array: [UIViewController] = []
        
        for var i = 0; i < 8; i++ {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let feedViewController = storyBoard.instantiateViewControllerWithIdentifier("FeedViewController") as! FeedViewController
            feedViewController.row = i
            array.append(feedViewController)
        }
        
        return array
    }
    
    // MARK: - SwipePagerDelegate
    
    func swipePager(swipePager: SwipePager, didMoveToPage page: Int) {
        print("move to :" + page.description)
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
