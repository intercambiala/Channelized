//
//  FileBrowserController.swift
//  Channelized
//
//  Created by Mauro Laurent on 1/9/15.
//  Copyright (c) 2015 Channelized. All rights reserved.
//

import UIKit

class FileBrowserController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let dismissButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    let myImage:UIImage! = UIImage(named: "round71")
    
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        view.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:20, left:10, bottom:10, right:10)
        layout.itemSize = CGSize(width: 90, height: 120)
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout:layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        
        if (myImage != nil) {
            
            let myImageView = UIImageView(image: myImage)
            myImageView.frame = view.frame
            myImageView.frame = CGRectMake(10, 10, 200, 200)
            view.addSubview(myImageView)
        
        }else { println("Image not found")}
        
        
        dismissButton.setTitle("Done", forState: .Normal)
        dismissButton.frame = CGRectMake(200, 10, 70, 20)
        dismissButton.addTarget(self, action: "PizzaDidFinish", forControlEvents: .TouchUpInside)
        view.addSubview(dismissButton)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int {
        
        return 14
    
    }
    
    func collectionView(collectionview: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionview.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
        
        cell.backgroundColor = UIColor.orangeColor()
        return cell
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
