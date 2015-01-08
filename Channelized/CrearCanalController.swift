//
//  CrearCanalController.swift
//  Channelized
//
//  Created by Mauro Laurent on 12/27/14.
//  Copyright (c) 2014 Channelized. All rights reserved.
//

import UIKit
import Foundation



class CrearCanalController: UIViewController, CatCanalDelegate {
    
  
    @IBOutlet weak var lbl_catName: UILabel!
   
    var CategoriaCanal = String()

    var canalCats = Dictionary<String, AnyObject>()
    var tableArray: [String] = Array()
    var tableArrDbl: [[String]] = Array()
    var tableDict = Dictionary<Int,String>() //Id, Nombre
    var SubCatTableDict = Dictionary<Int,String>() //Id, Nombre
    var mDic = NSMutableDictionary()
   
    let CategoriasCanalpopVC = vwpop_CategoriaCanal(nibName:"vwpop_CategoriaCanal", bundle:nil )
    
    func modalDidFinish(controller: vwpop_CategoriaCanal, catid: String) {
        CategoriaCanal = catid
       // lbl_catName.text = catname
        println(catid)
        
    }
    
    
    func didFinishCategoriasCanal(controller: CategoriasCanal) {
        //self.CategoriaCanal = controller.returnValue
    }
    
    
    
    
    @IBAction func btn_categoria(sender: AnyObject) {
        
        CategoriasCanalpopVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        presentViewController(CategoriasCanalpopVC, animated: true, completion:nil)
        
       /* let ccvc = CategoriasCanal(nibName:"CategoriasCanal", bundle: nil)
        
        ccvc.returnValue = self.CategoriaCanal
        ccvc.delegate = self
        
        navigationController?.pushViewController(ccvc, animated: true)*/
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Crear Nuevo Canal"
        
        //self.catCanalTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
       // CatsCanal()
        println(CategoriaCanal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func CatsCanal() {
        
        var server = BaseMethods.Server().Url
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
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var ii = indexPath.row
        var value = tableDict.keys.array[ii]
        
        SubCatsCanal(value)
        
    }
    
   
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest)!)!
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: nil, error: &error) as NSDictionary
        
        return boardsDictionary
    }
    
    
    func SubCatsCanal(padreId:Int) {
        
        var server = BaseMethods.Server().Url
        var urli = server + "categoriacanal?padreid=" + String(padreId)
        
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
                
                
                SubCatTableDict[idd] = nombre
                
            }
            
        }
        
    }

 
    
   }





