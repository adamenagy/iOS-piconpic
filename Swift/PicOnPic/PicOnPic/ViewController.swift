//
//  ViewController.swift
//  PicOnPic
//
//  Created by Adam Nagy on 09/11/2015.
//  Copyright © 2015 Adam Nagy. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController : UIViewController,
  UIImagePickerControllerDelegate,
  UINavigationControllerDelegate,
  UIPopoverControllerDelegate {

  var overlayImageView: UIImageView?
  var imageFromCamera = true;
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
		print("viewDidLoad")
		super.viewDidLoad()
	}
	
	override func didReceiveMemoryWarning() {
		print("didReceiveMemoryWarning")
		super.didReceiveMemoryWarning()
	}
  
  @IBAction func startCamera(sender: UIBarButtonItem) {
		print("startCamera")

		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
			let imagePicker: UIImagePickerController = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
			imagePicker.mediaTypes = NSArray(objects: kUTTypeImage) as! [String]
			imagePicker.allowsEditing = false
			presentViewController(
        imagePicker, animated: true, completion: {
          print("startCamera - completion")
          self.imageFromCamera = true
        })
		}
  }

	@IBAction func findPic(sender: UIBarButtonItem) {
		print("findPic")
    
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum) {
			let imagePicker: UIImagePickerController = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
			imagePicker.mediaTypes = NSArray(objects: kUTTypeImage) as! [String]
			imagePicker.allowsEditing = false
      presentViewController(
        imagePicker, animated: true, completion: {
          print("findPic - completion")
          self.imageFromCamera = false
        })
		}
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
		print("imagePickerController")
		picker.dismissViewControllerAnimated(true, completion: nil)
		let image: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
		// If it's a picture selection or
    // one from the camera
    if imageFromCamera {
      imageView.image = image
    } else {
      if (overlayImageView != nil) {
				overlayImageView!.removeFromSuperview()
			}
      
			overlayImageView = UIImageView(image: image)
			imageView.addSubview(overlayImageView!)
    }
	}
	
	@IBAction func pinch(sender: UIPinchGestureRecognizer) {
		print("pinch")
    struct funcData {
      static var origTr = CGAffineTransform()
    }
    
		if sender.state == UIGestureRecognizerState.Began {
			funcData.origTr = overlayImageView!.transform
		} else {
			if sender.state == UIGestureRecognizerState.Changed {
				let scale: CGFloat = sender.scale
				let tr: CGAffineTransform =
          CGAffineTransformConcat(funcData.origTr,CGAffineTransformMakeScale(scale,scale))
				overlayImageView!.transform = tr
			}
		}
	}
	
	@IBAction func pan(sender: UIPanGestureRecognizer) {
		print("pan")
    struct funcData {
      static var prevPt = CGPoint()
    }
    
		if sender.state == UIGestureRecognizerState.Began {
      print("pan - Began")
			funcData.prevPt = sender.locationInView(imageView)
		} else if sender.state == UIGestureRecognizerState.Changed {
      print("pan - Changed")
      let pt: CGPoint = sender.locationInView(imageView)
      let tr: CGAffineTransform = CGAffineTransformMakeTranslation(
          pt.x-funcData.prevPt.x,pt.y-funcData.prevPt.y)
      let cp: CGPoint =
        CGPointApplyAffineTransform(
          overlayImageView!.center,tr)
      overlayImageView!.center = cp
      funcData.prevPt = pt
		}
	}
	
	@IBAction func rotate(sender: UIRotationGestureRecognizer) {
		print("rotate")
    struct funcData {
      static var origTr = CGAffineTransform()
    }
    
		if sender.state == UIGestureRecognizerState.Began {
			funcData.origTr = overlayImageView!.transform
		} else {
			if sender.state == UIGestureRecognizerState.Changed {
				let rotation: CGFloat = sender.rotation
				// Scale
				let tr: CGAffineTransform =
          CGAffineTransformConcat(funcData.origTr,CGAffineTransformMakeRotation(rotation))
				overlayImageView!.transform = tr
			}
		}
	}
}

