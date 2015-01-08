//
//  CanalCrearController.swift
//  Channelized
//
//  Created by Mauro Laurent on 1/7/15.
//  Copyright (c) 2015 Channelized. All rights reserved.
//


import UIKit
import Foundation

class CanalCrearController: UIViewController {
    
    

    
    //Class to represent the channels categories
    class Canal {
        
        var Nombre: String
        var Id: Int?
        var Canales: [Canal] = []
        func AddCanal(cCanal: Canal ) { self.Canales.append(cCanal) }
        var Padre: Int?
        
        init(nombre: String) { self.Nombre = nombre}
        
       // var Canales = NSDictionary()
        //func AddCanal(cCanal: CatCanal, key:String) { self.Canales.setValue(cCanal, forKey: key)}
    
    }
    
    var tableDict = Dictionary<Int,String>() //Id, Nombre
    var canalesDict = Dictionary<Int,NSArray>() //Id, Canales
    var jsonDict = NSArray()
    
    
    var canales: Dictionary<Int,Canal> {
        
       
        
        
        var canales = Dictionary<Int,Canal>()
        
        for (ss) in jsonDict {
            
            
            
            let secc = ss as NSDictionary
            var nombre = secc.valueForKey("Nombre") as? String
            
            var sec = Canal(nombre: nombre!)
            
            //Primero ocupamos los canales de esta seccion, preguntandole al canal siendo iterado sus canales
            var id:Int = secc.valueForKey("id") as Int
            sec.Id = id
            sec.Nombre = secc.valueForKey("Nombre") as String!
  
            for cc in canalesDict.values {
            
                for ccarr in cc {
                    
                    let canalHijo = ccarr as NSDictionary
                    var chnombre = canalHijo.valueForKey("Nombre") as? String
                    var chid = canalHijo.valueForKey("id") as? Int
                    var chpadre = canalHijo.valueForKey("Padre") as? Int
                    
                    var catCanal = Canal(nombre: chnombre!)
                        catCanal.Id = chid
                        catCanal.Padre = chpadre
                    sec.AddCanal(catCanal)
                
                }
     
            }
            
        }
        
        //self._canales = self.canales
        
        return canales
        
    }
    
    //var _canales: Dictionary<Int,Canal>?
    

    
    //Outlets
    @IBOutlet weak var tbl_categorias: UITableView!
    
    
    
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
    
        jsonDict = jsonResult as NSArray
        
        for(kk) in jsonDict {
            
            let obj = kk as NSDictionary
            
            for (key, value) in obj {
                
                var nombre:String = obj.valueForKey("Nombre") as String
                var idd:Int = obj.valueForKey("id") as Int
                var canales:AnyObject? = obj.valueForKey("CategoriaHijos") as? [AnyObject]
                
                var canArray = canales as NSArray
                
                tableDict[idd] = nombre
                canalesDict[idd] = canArray
            }
            
        }
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView!)
        -> Int {
            return self.canales.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection seccion: Int) -> Int
    {
        var sec:Canal = canales[seccion]!
        var res:Int = Int(sec.Canales.count)
        
        return res
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        
        let cCanal = self.canales[indexPath.section]?.Canales[indexPath.row]
        var cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"catCanalCell")

        cell.textLabel?.text =  cCanal?.Nombre
        return cell
        
    }
    
    //headers
    func tableView(tableView: UITableView, titleForHeaderInSection section:Int) -> String {
        
        
        var sd = self.canales[section]
        
        let numberOfChannels = self.canales[section]?.Canales.count
        
        //Do not display emptys
        if ( numberOfChannels != 0) {
            
            return sd!.Nombre
        }
        
        return ""
    }
    
  // func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject] {
        
        //To be implemented
        //It displays a small array of indexes at the right of the screen, representing something like the alphabet of the phonebook app
    
    //}
    
    
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var ii = indexPath.row
        
        var catId:String! = String(tableDict.keys.array[ii])
        let catNombre:String! = tableDict.values.array[ii]
        
        println(catId)
        
        
    }
   
}
