//
//  RegistroController.swift
//  Channelized
//
//  Created by Mauro Laurent on 12/27/14.
//  Copyright (c) 2014 Channelized. All rights reserved.
//

import UIKit



class RegistroController: UIViewController {

    
    @IBOutlet weak var txtreg_nombre: UITextField!
   
    @IBOutlet weak var txtreg_apellido: UITextField!
    
    @IBOutlet weak var txtreg_email: UITextField!
    
    @IBOutlet weak var txtreg_usuario: UITextField!
    
    @IBOutlet weak var txtreg_password: UITextField!
    
    @IBOutlet weak var txtreg_password_confirm: UITextField!
    
    
    @IBAction func btn_registro(sender: UIButton) {
        
        //var usr = BaseMethods.Usuario()
        
      
        var password_repeat = self.txtreg_password_confirm.text
        
        var usuario = [  "Nombre": self.txtreg_nombre.text
                        ,"Apellido": self.txtreg_apellido.text
                        ,"Email": self.txtreg_email.text
                        ,"Username": self.txtreg_usuario.text
                        ,"Password": self.txtreg_password.text
            
                    ]
        

        var server = Server().Url
        
        var urli = server + "usuario/post"
        /*?" +
        "Nombre=" + usuario +
        "&Apellido=" + apellido
        "&Usuario=" + usuario
        "&Email=" + email
        "&Password=" + password*/
        
        
        
        if(txtreg_usuario.text != nil && txtreg_password.text != nil) {
            
            var jsonObject:String = BaseMethods.JSONStringify(usuario, prettyPrinted: false)
            
            
            BaseMethods.HTTPPostJSON(urli, jsonObj: usuario ){ (data: String, error: String?) -> Void in
                
                
                if (data != "") {
                    let dictionary = BaseMethods.JSONParseDictionary(data)
                    
                    var usr = Usuario()
                    
                    usr.Username = dictionary["Username"] as String;
                    usr.Nombre = dictionary["Nombre"] as String;
                    usr.Apellido = dictionary["Apellido"] as String;
                    usr.Email = dictionary["Email"] as String;
                    usr.Id = dictionary["Id"] as Int;
                    
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.performSegueWithIdentifier("segreg_canales", sender: self)
                    }
                    
                }
                else {//Print error
                }
                
                
            }
            
        }
        
    }
    
    
    func DoUserRegistry() {
        
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
