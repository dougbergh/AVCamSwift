//
//  AVCamSwift
//
//  Created by DBergh on 11/9/15.
//  Copyright © 2015 sunset. All rights reserved.
//

import Foundation
import UIKit

class ImageViewController : UIViewController {
    
    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var imageView: UIImageView!

    @IBAction func returnButtonPressed(sender: UIButton) {
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
            let image:UIImage = UIImage(data: fileContent!)!
            imageView.image = image
        }
    }
}
