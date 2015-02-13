//
//  FileBrowserController.swift
//  Channelized
//
//  Created by Mauro Laurent on 1/9/15.
//  Copyright (c) 2015 Channelized. All rights reserved.
//

import UIKit



class VWFile {
    
     var Url:String = ""
    var Type:String = ""
    var Title:String = ""

}

class FileBrowserController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    let dismissButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    let img_back:UIImage! = UIImage(named: "round71")
    let img_folder:UIImage! = UIImage(named: "folder")
    let img_box:UIImage! = UIImage(named: "box")
    
    var baseDirArr:[String] = ["/Users/","Mauro/"]
    
    
    var CurrentDirectoriesView = [VWFile]()
  

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GetDirectoryContents()
        
        modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        view.backgroundColor = UIColor(red:1, green:1, blue:1, alpha:1)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:20, left:10, bottom:10, right:20)
        layout.itemSize = CGSize(width: 100, height: 100)
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout:layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        
        
        
       /* dismissButton.setTitle("Done", forState: .Normal)
        dismissButton.frame = CGRectMake(200, 10, 70, 20)
        dismissButton.addTarget(self, action: "PizzaDidFinish", forControlEvents: .TouchUpInside)
        view.addSubview(dismissButton)*/
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section:Int) -> Int {
        
        return CurrentDirectoriesView.count
    
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell
        
        var baseDir = GetCurrentDirectoryString()


        
        var file = CurrentDirectoriesView[indexPath.item]
        var fileDir = file.Title +  "/"
        
        switch(file.Type) {
            
            case "NSFileTypeRegular":
                //ToDo: Ask for confirmation before sending the video
                
                var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
                var filePath:String = baseDir + file.Title
                let wData = NSData(contentsOfFile: filePath)
                let videoData = wData?.base64EncodedDataWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                let videoAsString64 = videoData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.allZeros)
                
                let userId:Int = defaults.objectForKey("lgdus_id") as Int
                
                var server = Server().Url
                //var urli = server + "Media?video=" + videoAsString64! + "&UserId=" + userId
                var urli = server + "Media"
                
                var params = [
                    "video": videoAsString64!
                    ,"UserID": userId
   
                ]
                
                
                var parameters = NSMutableDictionary(objectsAndKeys: videoAsString64!, "video", userId, "UserID")
                
              
                
                
                let session = NSURLSession.sharedSession()
            
                var error = NSErrorPointer()
                
                let manager = AFHTTPRequestOperationManager()
                
                
                var url:NSURL = NSURL(string:urli)!
                var request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.HTTPMethod = "POST"
                request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions.allZeros , error: error)
                
            
                
                let dataTask = session.dataTaskWithRequest(request) { data, response, error in
                    println(data)
                    println(response)
                    println(error)
                    
                    let jsonString = BaseMethods.JSONStringify(data)
                    if (jsonString != "") {
                        let dictionary = BaseMethods.JSONParseDictionary(jsonString)
                        
                        
                        
                    }
                   
                }
                
                dataTask.resume()
                

               
                break;
            
            case "NSFileTypeDirectory":
                baseDirArr.append(fileDir)
                
                for ccol in collectionView.visibleCells() {
                    
                    for svw in ccol.subviews {
                        
                        svw.removeFromSuperview()
                    }
                    
                    ccol.removeFromSuperview()
                    
                }
                
                
                
                InitializeCurrentDirectoriesView()
                GetDirectoryContents()
                collectionView.reloadData()
                break;
            case "V":
                baseDirArr.removeLast()
                break;
            
           default:
            
                break;
        
        }
    }
    
    
    func collectionView(collectionview: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
       
        //let cell = UICollectionViewCell()
        let cell = collectionview.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as UICollectionViewCell

        var file = VWFile()
       
        file = CurrentDirectoriesView[indexPath.item]
        
        let fImg = UIImageView()
        
        switch(file.Type) {
        
        case "V":
            fImg.image = img_back
        
        case "NSFileTypeRegular":
            fImg.image = img_box
            break;
            
        case "NSFileTypeDirectory":
            
            fImg.image = img_folder

            
            break;
            
        default:

            
            break;
        }
        
         fImg.frame = CGRectMake(25, 10, 48, 48)
         cell.addSubview(fImg)
        
        let tFrmLabel = CGRectMake(0, 50, cell.frame.size.width, cell.frame.size.height / 3)
        let textLabel = UILabel(frame: tFrmLabel)
        textLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        textLabel.textAlignment = .Center
        textLabel.text = file.Title
        
        cell.addSubview(textLabel)
        
        cell.backgroundColor = UIColor(red:0.9, green:0.9, blue:0.9, alpha:1)
        
        return cell
    }
    
    func GetCurrentDirectoryString() -> String {
        
        var result:String = ""
        
        for s in baseDirArr { result += s }
        
        return result
    
    }
    
    func InitializeCurrentDirectoriesView() {
 
        CurrentDirectoriesView.removeAll(keepCapacity: false)
        
        var ff = VWFile()
        ff.Title = "Volver"
        ff.Type = "V"
        
        
        CurrentDirectoriesView.append(ff)

    }
    
    
    func GetDirectoryContents() {
        
     
      // InitializeCurrentDirectoriesView()
        
       var error = NSErrorPointer()
       var fileops = NSFileManager.defaultManager()

        var baseDir = GetCurrentDirectoryString()
        
        //println(baseDir)
        let dirConts = fileops.contentsOfDirectoryAtPath(baseDir, error: error) as [String]
        
        
        for (var i:Int, dir) in enumerate(dirConts) {
            
            var file = VWFile()
            
            var err = NSErrorPointer()
            
            let dirUrl  = baseDir + dir
            var dirInfo = fileops.attributesOfItemAtPath(dirUrl, error: err)
            
            var dInfo = dirInfo as Dictionary!
            var fi = dInfo.valuesForKeys(["NSFileType"])
           
            
            file.Url = dirUrl
            file.Type = fi[0] as String
            file.Title = dir
          
            //Filter system files
            
            switch(file.Type) {
                
                
            case "NSFileTypeRegular":
                if((file.Title[0...0] != ".") && (file.Title.rangeOfString(".mp4")) != nil) {
                    
                    CurrentDirectoriesView.append(file)
                    
                }
                break;
                
            case "NSFileTypeDirectory":
                
                CurrentDirectoriesView.append(file)

                
                
                break;
                
            default:
                
                
                break;
            }

            
            
            
            
 
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

extension Dictionary {
    
    func valuesForKeys(keys: [Key]) -> [Value?] {
        return keys.map {self[$0]}
    }
}

extension String {
    
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        
        }
        
    }

}
