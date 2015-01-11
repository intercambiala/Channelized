//
//  CanalCrear.swift
//  Channelized
//
//  Created by Mauro Laurent on 1/8/15.
//  Copyright (c) 2015 Channelized. All rights reserved.
//

import UIKit
import Foundation

class CanalCrear: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate
{
    
    
    

    @IBOutlet weak var pck_categorias: UIPickerView!
   
    @IBOutlet weak var txt_nombreCanal: UITextField!
    @IBOutlet weak var nav: UINavigationBar!
    @IBOutlet weak var swt_privado: UISwitch!
    @IBOutlet weak var swt_adultos: UISwitch!
    @IBOutlet weak var txt_descripcion: UITextField!
    
    @IBAction func btn_guardarCanal(sender: AnyObject) {
        
        let cat:Int = pck_categorias.selectedRowInComponent(1)
        var sc:Int = listaCanales[cat].Id as Int!
        
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        var ccanl = [
             "Nombre": self.txt_nombreCanal.text!
            ,"Descripcion": self.txt_descripcion.text!
            ,"Adultos": Int(self.swt_privado.selected)
            ,"Privado": Int(self.swt_privado.selected)
            ,"Categoria": sc
            ,"Creador": defaults.objectForKey("lgdus_id") as Int
            
        ]
        
        
        var server = Server().Url
        
        var urli = server + "canal/post"

            BaseMethods.HTTPPostJSON(urli, jsonObj: ccanl ){ (data: String, error: String?) -> Void in
                
                
                if (data != "") {
                    
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.performSegueWithIdentifier("seg_canal_crear_to_index", sender: self)
                    }
                    
                }
                else {//Print error
                }
                
                
        }
        
        
        
        
    }
    //MARK  -Outlets and properties
    var arrayCatsPadre:[String] = []
    var arrayCatsHijas: [String] = []
    var pickerData: [[String]] = []
    
    var listaCanales = [Canal]()

    
    enum PickerComponent:Int{
        case size = 0
        case topping = 1
    }

    //MARK -Instance Methods
    func updateLabel(){
        var sizeComponent = PickerComponent.size.rawValue
        let toppingComponent = PickerComponent.topping.rawValue
        let size = pickerData[sizeComponent][pck_categorias.selectedRowInComponent(sizeComponent)]
        let topping = pickerData[toppingComponent][pck_categorias.selectedRowInComponent(toppingComponent)]
        
        OverridePickerRows()
        
        
        //This is where you fill the second picker

    }
    
    func OverridePickerRows() {
        
        pck_categorias.reloadAllComponents()
    
    }
    
    //MARK -Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CatsCanal()
  
        pck_categorias.delegate = self
        pck_categorias.dataSource = self
        pck_categorias.selectRow(0, inComponent: PickerComponent.size.rawValue, animated: false)
        
      

        
        
    }
    
    func GoBack(sender:UIBarButtonItem) {
        
        NSOperationQueue.mainQueue().addOperationWithBlock {
            self.performSegueWithIdentifier("seg_canal_crear_to_index", sender: self)
        }
        
        
    }
    
    //MARK -Delgates and DataSource
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if(component == 0 ) {
            
            ManageSecondPickerData(row)
        
        }
       
        pickerView.reloadComponent(1)
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[component][row]
    }
    
    func ManageSecondPickerData(id:Int) {

        pickerData = [[String]]()
        arrayCatsHijas = [String]()
        
        
        
        var primerCanal:Canal = listaCanales[id]
        for cc in primerCanal.CanalHijos {
            
            arrayCatsHijas.append(cc.Nombre)
            
        }
        pickerData.append(arrayCatsPadre)
        pickerData.append(arrayCatsHijas)
        
        OverridePickerRows()
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
        
        var jsonDict:NSArray = jsonResult as NSArray
        
        for(kk) in jsonDict {
            
            let obj = kk as NSDictionary
            
            
            var nom:String = obj.valueForKey("Nombre") as String
            var cCanal = Canal(nombre: nom)
                cCanal.Id = obj.valueForKey("id") as? Int
            
            var categoriasHijos:AnyObject? = obj.valueForKey("CategoriaHijos") as? [AnyObject]
            var canArray = categoriasHijos as NSArray
            
            for hj in canArray {
                
                let hijo = hj as NSDictionary
                
                var nomHj:String = hijo.valueForKey("Nombre") as String
                
                var catHijo = Canal(nombre: nomHj)
                    catHijo.Id = obj.valueForKey("id") as? Int
                    catHijo.Padre = obj.valueForKey("Padre") as? Int
                
                cCanal.AddCanal(catHijo)
            
            }
            
            listaCanales.append(cCanal)
         
            arrayCatsPadre.append(cCanal.Nombre)
          
            
        }
        
        
        ManageSecondPickerData(0)
       
        
    }
    

}


