//
//  ViewController.swift
//  OCR-Mobile-Vision
//
//  Created by Pawan kumar on 24/01/20.
//  Copyright © 2020 Pawan Kumar. All rights reserved.
//

import UIKit
import GoogleMobileVision


struct ReadItem {
    var title: String = ""
}

class ViewController: UIViewController {
    
    @IBOutlet weak var chooseImageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    
    //Declare Local Array here
    var wordlists: Array <ReadItem> = Array <ReadItem>()
    
    var textDetector: GMVDetector?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //daynamic Height Set
        self.tableView.estimatedRowHeight = 1 //Use less when recived data No 0 otherwise not set cell size default
        self.tableView.rowHeight = UITableView.automaticDimension
        
        textDetector = GMVDetector(ofType: GMVDetectorTypeText, options: nil)
            
        let images = ["Pawan_en.png","Pawan_de.png","Pawan_fr.png","Pawan_jp.png","Pawan_ru.png"]
        
        recognizeImageWithTesseract(image: UIImage(named: images[0])!)
    }
    
    func recognizeImageWithTesseract(image: UIImage) -> () {
        
        //Loader
               self.activityIndicatorView.startAnimating()
               self.activityIndicatorView.isHidden = false
               
               self.chooseImageView.image = image
               
               self.wordlists.removeAll()
               self.wordlists = []
            
        let features: Array<GMVTextBlockFeature> = self.textDetector!.features(in: image, options: nil) as! Array<GMVTextBlockFeature>
        
            if features.count > 0 {

            // Iterate over each text block.
                
                for textBlock:GMVTextBlockFeature in features {
                    print("lang: \(textBlock.language) textBlock value: \(textBlock.value)")
                                
                    // For each text block, iterate over each line.
                    for textLine:GMVTextLineFeature in textBlock.lines {
                    
                        print("lang: \(textLine.language) textLine value: \(textLine.value)")
            
                        self.wordlists.append(ReadItem.init(title: textLine.value))
                        
                        for element:GMVTextElementFeature in textLine.elements {
                        
                            //print("lang: \(element.language) textLine value: \(element.value)")
                        }
                    }
                }
            }
        
        DispatchQueue.main.async {
           
         self.tableView.reloadData()
         
         //Loader
         self.activityIndicatorView.stopAnimating()
         self.activityIndicatorView.isHidden = true
        
        }
    }
}


//#MARK:- UITableView DataSource & Delegate

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
    }
    //PK-New-Added
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.wordlists.count > 0 {
            return self.wordlists.count
        }
       return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier: String = "ReadCell"
        var cell : ReadCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ReadCell
        if (cell == nil)
        {
            let nib: Array = Bundle.main.loadNibNamed(cellIdentifier, owner: self, options: nil)!
            cell = nib[0] as? ReadCell
        }
        
        let readItem: ReadItem  = self.wordlists[indexPath.row]
        
        //cell?.titleLabel.text? = NSLocalizedString(readItem.title, comment: "")
        cell?.titleLabel.text? = readItem.title
        
        //Cell Selection
        cell?.selectionStyle = .none
            
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let readItem: ReadItem  = self.wordlists[indexPath.row]
        print("readItem:- ", readItem)
    }
}
