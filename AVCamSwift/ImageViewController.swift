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
    
    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        if let detail = self.detailItem {
            if let imageView = self.imageView {
                imageView.image = UIImage(named: detail)
            }
        }
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
//            do {
//                let text2 = try NSString(contentsOfFile: imagePath, encoding: NSUTF8StringEncoding)
//                print (text2)
//            }
//            catch {/* error handling here */}
            

//            imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x:30, y:30, width:160, height: 200)
//            imageView.startAnimating()
//            self.loadView()