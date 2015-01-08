//
//  CanalCrear.swift
//  Channelized
//
//  Created by Mauro Laurent on 1/8/15.
//  Copyright (c) 2015 Channelized. All rights reserved.
//

import UIKit
import Foundation

class CanalCrear: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    @IBOutlet weak var pck_categorias: UIPickerView!
    
    //MARK  -Outlets and properties
    var arrayCatsPadre:[String] = []
    var arrayCatsHijas:[String] = []
    var pickerData: [[String]] = []
    
    
    
    
  /*  let pickerData = [
        ["10\"","14\"","18\"","24\""],
        ["Cheese","Pepperoni","Sausage","Veggie","BBQ Chicken"]
    ]*/
    
    
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
      //  myLabel.text =
        println("Pizza: " + size + " " + topping)
    }
    
    //MARK -Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CatsCanal()
        
        
        
        pck_categorias.delegate = self
        pck_categorias.dataSource = self
        pck_categorias.selectRow(2, inComponent: PickerComponent.size.rawValue, animated: false)
        
        updateLabel()
    }
    //MARK -Delgates and DataSource
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        updateLabel()
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
        
        var jsonDict:NSArray = jsonResult as NSArray
        
        for(kk) in jsonDict {
            
            let obj = kk as NSDictionary
            
            var nombre:String = obj.valueForKey("Nombre") as String
            
            arrayCatsPadre.append(nombre)
            
        }
        
        pickerData.append(arrayCatsPadre)
        pickerData.append(arrayCatsPadre)
    }
    
}


