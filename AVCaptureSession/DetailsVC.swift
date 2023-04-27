//
//  DetailsVC.swift
//  AVCaptureSession
//
//  Created by ShafiulAlam-00058 on 3/20/23.
//

import UIKit

class DetailsVC: UIViewController {
    
    var takenPhoto: UIImage?
    
    @IBOutlet weak var showPicture: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let haveImage = takenPhoto {
            showPicture.image = haveImage
        }
    }
}
