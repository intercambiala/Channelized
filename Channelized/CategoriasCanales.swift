//
//  CategoriasCanales.swift
//  Channelized
//
//  Created by Mauro Laurent on 1/6/15.
//  Copyright (c) 2015 Channelized. All rights reserved.
//


import UIKit
import Foundation

protocol CategoriaCanalDelegate{
    func didFinishCategoriasCanal(controller:CategoriasCanal)
}

class CategoriasCanal: UIViewController{
    
    var tableDict = Dictionary<Int,String>() //Id, Nombre
    var returnValue = Int()
    
    
    @IBOutlet weak var catsCanalTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Crear Nuevo Canal"
        
        
        CatsCanal()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func CatsCanal() {
        
        var server = Server().Url
        var urli = server + "categoriacanal?padreid=null"
        
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
        
        
        var jsonDict: NSArray = jsonResult as NSArray
        
        for(kk) in jsonDict {
            
            let obj = kk as NSDictionary
            
            for (key, value) in obj {
                
                
                var nombre:String = obj.valueForKey("Nombre") as String
                
                var idd:Int = obj.valueForKey("id") as Int
                
                
                tableDict[idd] = nombre
                
            }
            
        }
    }
    
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableDict.count
    }
    
    
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"catCanalCell")
        var ii = indexPath.row
        cell.textLabel?.text =  tableDict.values.array[ii]
        return cell
        
    }
    
    var delegate:CategoriaCanalDelegate!=nil
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var ii = indexPath.row
        returnValue = tableDict.keys.array[ii]
        
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.performSegueWithIdentifier("seg_categoriaCanales", sender: self)
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "seg_categoriaCanales"{
            let vc = segue.destinationViewController as CrearCanalController
           // vc.CategoriaCanal = returnValue
            
        }
    }

}