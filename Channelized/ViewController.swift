//
//  ViewController.swift
//  Channelized
//
//  Created by Mauro Laurent on 12/26/14.
//  Copyright (c) 2014 Channelized. All rights reserved.
//

import UIKit
import Foundation

class BaseMethods {
    
    
    //BASE CLASSES
    
        
    //END BASE CLASSES
    
    
    
    //REGION HELPERS
    
   
    
    
    class func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
        var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
        if NSJSONSerialization.isValidJSONObject(value) {
            if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string
                }
            }
        }
        return ""
    }
    
    
    class func HTTPsendRequest(request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(
                request,
                {
                    data, response, error in
                    if error != nil {
                        callback("", error.localizedDescription)
                    } else {
                        callback(
                            NSString(data: data, encoding: NSUTF8StringEncoding)!,
                            nil
                        )
                    }
            })
            
            task.resume()
            
    }
    
    class func JSONParseDictionary(jsonString: String) -> [String: AnyObject] {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding) {
            if let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil) as? [String: AnyObject] {
                return dictionary
            }
        }
        return [String: AnyObject]()
    }
    
    class func JSONParseDict(jsonString:String) -> Dictionary<String, AnyObject> {
        var e: NSError?
        var data: NSData = jsonString.dataUsingEncoding(
            NSUTF8StringEncoding)!
        var jsonObj = NSJSONSerialization.JSONObjectWithData(
            data,
            options: NSJSONReadingOptions(0),
            error: &e) as Dictionary<String, AnyObject>
        if (e != nil) {
            return Dictionary<String, AnyObject>()
        } else {
            return jsonObj
        }
    }
    
    class func HTTPGetJSON(
        url: String,
        callback: (Dictionary<String, AnyObject>, String?) -> Void) {
            
            var request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            HTTPsendRequest(request) {
                (data: String, error: String?) -> Void in
                if (error != nil) {
                    callback(Dictionary<String, AnyObject>(), error)
                } else {
                   
                  
                        var jsonObj = self.JSONParseDict(data)
                        callback(jsonObj, nil)
                    
                }
            }
    }
    
    
    class func HTTPGetJSONStrDict(
        url: String,
        callback: (Dictionary<String, AnyObject>, String?) -> Void) {
            
            var request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            HTTPsendRequest(request) {
                (data: String, error: String?) -> Void in
                if (error != nil) {
                    callback(Dictionary<String, AnyObject>(), error)
                } else {
                    
                    
                    var jsonObj = self.JSONParseDictionary(data)
                    callback(jsonObj, nil)
                    
                }
            }
    }
    
    
    
     class func HTTPPostJSON(url: String,
        jsonObj: AnyObject,
        callback: (String, String?) -> Void) {
            
            var request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            request.addValue("application/json",
                forHTTPHeaderField: "Content-Type")
            let jsonString = JSONStringify(jsonObj)
            let data: NSData = jsonString.dataUsingEncoding(
                NSUTF8StringEncoding)!
            request.HTTPBody = data
            HTTPsendRequest(request, callback)
    }
    
    
    //END REGION HELPERS
}



class ViewController: UIViewController {
    
    
    var usuario = Usuario()
    
    @IBOutlet weak var txt_usuario: UITextField!
    
    @IBOutlet weak var lbl_error: UILabel!
    @IBOutlet weak var txt_password: UITextField!
    
    
    
    @IBAction func btn_login(sender: AnyObject) {
        
        var actInd : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0, 50, 50)) as UIActivityIndicatorView
        actInd.center = self.view.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(actInd)
        actInd.startAnimating()
        
        DoLogin()
        
        actInd.stopAnimating()
      
    }

    func DoLogin() {
        
        var user = txt_usuario.text
        var pass = txt_password.text
        var server = Server().Url
        
        var urli = server + "usuario/get?user=" + user + "&pass=" + pass
        
        
        if(user != nil && pass != nil) {
            
            BaseMethods.HTTPGetJSON(urli) {
                (data: Dictionary<String, AnyObject>, error: String?) -> Void in
                if (error != nil) {
                    self.lbl_error.text = "Las credenciales son incorrectas"
                } else {
                    
                    
                    let jsonString = BaseMethods.JSONStringify(data)
                    if (jsonString != "") {
                        let dictionary = BaseMethods.JSONParseDictionary(jsonString)
                        
                        
                        self.usuario.Username = dictionary["Username"] as String;
                        self.usuario.Nombre = dictionary["Nombre"] as String;
                        self.usuario.Apellido = dictionary["Apellido"] as String;
                        self.usuario.Email = dictionary["Email"] as String;
                        self.usuario.Id = dictionary["Id"] as Int;
                        
                        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                        
                        defaults.setObject(self.usuario.Id, forKey: "lgdus_id")
                        
                        defaults.synchronize()
                        
                        
                        NSOperationQueue.mainQueue().addOperationWithBlock {
                            self.performSegueWithIdentifier("seg_canales", sender: self)
                        }
                        
                    }
                    else {self.lbl_error.text = "Las credenciales son incorrectas"
                    }
                    
                }
            }
            
        }
        else {self.lbl_error.text = "Necesita suplir credenciales para ingresar"
        }


    
    }
    



    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
    }
    
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "seg_canales"{
            let vc = segue.destinationViewController as Canales
            vc.loggedUser = usuario
            
        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
   
}

