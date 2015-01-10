//
//  MisCanalesController.swift
//  Channelized
//
//  Created by Mauro Laurent on 1/9/15.
//  Copyright (c) 2015 Channelized. All rights reserved.
//

import UIKit

class MisCanalesController: UIViewController {

    @IBOutlet weak var tbl_miscanales: UITableView!
    
    var canales:[Canal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CanalesUsuario()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return canales.count
    }
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"catCanalCell")
        var ii = indexPath.row
        cell.textLabel?.text =  canales[ii].Nombre
        return cell
        
    }
    
   
    
    
    
    func CanalesUsuario() {
        
        

        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var userId = String(defaults.objectForKey("lgdus_id") as Int)
        
        var server = Server().Url
        var urli = server + "canal?UserId=" + userId
        
        var url:NSURL = NSURL(string:urli)!
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.HTTPMethod = "GET"
        
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>= nil
        var error: NSErrorPointer = nil
        var dataVal: NSData = NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: error)!
        var err: NSError?
        var jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions(0), error: &err)
        
        var jsonDict = jsonResult as NSArray
        
        for(kk) in jsonDict {
            
            let obj = kk as NSDictionary
            
            var ccnl:Canal = Canal(nombre: obj.valueForKey("Nombre") as String)
            
            ccnl.Id = obj.valueForKey("id") as? Int
            
            ccnl.Descripcion = obj.valueForKey("Descripcion") as? String
            ccnl.Categoria = obj.valueForKey("Categoria") as? Int
            ccnl.Adultos = obj.valueForKey("Adultos") as Bool
            ccnl.Privado = obj.valueForKey("Privado") as Bool
            
            
            canales.append(ccnl)
            
        }
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
