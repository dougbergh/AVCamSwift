//
//  AVCamSwift
//
//  Created by DBergh on 11/9/15.
//  Copyright © 2015 sunset. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet var driverLicenseTable: UITableView!
    
    @IBAction func returnButtonPressed(sender: UIButton) {
        print("return pressed")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findAndDisplayImage()
    }
    
    func findAndDisplayImage () {
        
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        
        if paths.count > 0 {
            let dirPath = paths[0]
            let imagePath = "\(dirPath)/Image.jpg"
            
            print( "reading from \(imagePath)" )
            
            let fileContent = NSData(contentsOfFile: imagePath)
            let directImage:UIImage = UIImage(data: fileContent!)!
            let image:UIImage = UIImage(CGImage:directImage.CGImage!, scale: 1.0, orientation: .Up)
            imageView.image = image
        }
    }
    
    var driverLicense:[(key:String,value:String)] = []
    
    //        driverLicense = (shoCardPresenter?.getDriverLicense())!
    //        driverLicenseTable.reloadData()     // with any luck, results in calls to TableView methods

    // UITableViewDataSource protocol methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return driverLicense.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        
        cell.textLabel?.text = driverLicense[indexPath.row].key
        cell.detailTextLabel?.text = driverLicense[indexPath.row].value
        
        return cell
    }
    
    func setDriverLicense(params: [(key: String, value: String)]) {
        driverLicense = params
        driverLicenseTable.reloadData()
    }
    
}
