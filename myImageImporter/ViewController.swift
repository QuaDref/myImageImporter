//
//  ViewController.swift
//  myImageImporter
//
//  Created by Zoe Berthold on 8/5/18.
//  Copyright © 2018 Zoe Berthold. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var myImageView: UIImageView!
    var imageArray = [UIImage]()
    var bottomImageArray = [UIImage]()
    var whichImage = 0
    var whichBottomImage = 0
    var imageControllerArray = [UIImageView]()
    var bottomImageControllerArray = [UIImageView]()
    var whichImageController = 0
    
    var videoURL: NSURL?
    let image = UIImagePickerController()
    override func viewDidLoad() {
        super.viewDidLoad()
        imageControllerArray.append(myImageView)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func importImage(_ sender: Any) {
        whichImageController = 0
        
        image.sourceType = .photoLibrary
        image.delegate = self
        image.mediaTypes = ["public.image", "public.movie"]
        image.allowsEditing = false
        self.present(image, animated: true, completion: nil)
        
    }
    
    @IBAction func importBottomImage(_ sender: Any) {
        whichImageController = 1
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        self.present(image, animated: true){
            //after its complete
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(imageControllerArray[whichImageController])
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageControllerArray[whichImageController].frame.size.height = CGFloat(image.topCapHeight)
            if(whichImageController == 0){
                imageArray.insert(image, at: 0)
                imageControllerArray[whichImageController].image = image
            }
            else{
                bottomImageArray.insert(image, at: 0)
                imageControllerArray[whichImageController].image = image
            }
        }
        else{
            //error message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if(imageArray.count > 1){
            if(whichImage < imageArray.count - 1){
                whichImage += 1
                myImageView.image = imageArray[whichImage]
            }
            else{
                whichImage = 0
                myImageView.image = imageArray[whichImage]
            }
        }
    }
    @IBAction func previousButton(_ sender: Any) {
        if(imageArray.count > 1){
            if(whichImage > 0){
                whichImage -= 1
                myImageView.image = imageArray[whichImage]
            }
            else{
                whichImage = imageArray.count - 1
                myImageView.image = imageArray[whichImage]
            }
        }
        
    }
    
    @IBAction func bottomPrevious(_ sender: Any) {
        if(bottomImageArray.count > 1){
            if(whichBottomImage > 0){
                whichBottomImage -= 1
                secondImageView.image = bottomImageArray[whichBottomImage]
            }
            else{
                whichBottomImage = bottomImageArray.count - 1
                secondImageView.image = bottomImageArray[whichBottomImage]
            }
        }
    }
    @IBAction func bottomNext(_ sender: Any) {
        print(bottomImageArray.count)
        print(whichBottomImage)
        if(bottomImageArray.count > 1){
            if(whichBottomImage < (bottomImageArray.count - 1)){
                whichBottomImage += 1
                secondImageView.image = bottomImageArray[whichBottomImage]
            }
            else{
                whichBottomImage = 0
                secondImageView.image = bottomImageArray[whichBottomImage]
            }
        }
    }
    
    func previewImageFromVideo(url:NSURL) -> UIImage? {
        let asset = AVAsset(url:url as URL)
        let imageGenerator = AVAssetImageGenerator(asset:asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        var time = asset.duration
        time.value = min(time.value,2)
        
        do {
            let imageRef = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            return UIImage(cgImage: imageRef)
        } catch {
            return nil
        }
    }
    
    func image(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        videoURL = info["UIImagePickerControllerReferenceURL"] as? NSURL
        
        print(videoURL)
        
        myImageView.image = previewImageFromVideo(url: videoURL!)!
        
        myImageView.contentMode = .scaleAspectFit
        
        image.dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        image.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func videoTapped(sender: UITapGestureRecognizer) {
        
        print("button tapped")
        
        if let videoURL = videoURL{
            
            let player = AVPlayer(url: videoURL as URL)
            
            let playerViewController = AVPlayerViewController()
            playerViewController.player = player
            
            present(playerViewController, animated: true){
                playerViewController.player!.play()
            }
        }
    }

}

