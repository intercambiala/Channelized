//
//  NavControllerViewController.swift
//  Channelized
//
//  Created by Mauro Laurent on 1/8/15.
//  Copyright (c) 2015 Channelized. All rights reserved.
//

import UIKit

class NavControllerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        var nav = UINavigationController(rootViewController: self)
        
        
        nav.setNavigationBarHidden(false, animated: true)
        nav.title = "Crear Nuevo Canal"
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        backButton.addTarget(self, action: "GoBack", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setTitle("Regresar", forState: UIControlState.Normal)
        backButton.sizeToFit()
        
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        nav.navigationItem.leftBarButtonItem = customBackButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
