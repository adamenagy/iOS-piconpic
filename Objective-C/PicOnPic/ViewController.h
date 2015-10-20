//
//  ViewController.h
//  PicOnPic
//
//  Created by Adam Nagy on 20/10/2012.
//  Copyright (c) 2012 Adam Nagy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<
  UINavigationControllerDelegate,
  UIImagePickerControllerDelegate,
  UIPopoverControllerDelegate>

- (IBAction)startCamera:(id)sender;

- (IBAction)findPic:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView * imageView;
@property (strong, nonatomic) UIImageView * overlayImageView;
@property (strong, nonatomic) UIPopoverController * popoverController;

- (IBAction)rotate:(UIRotationGestureRecognizer *)sender;
- (IBAction)pinch:(UIPinchGestureRecognizer *)sender;
- (IBAction)pan:(UIPanGestureRecognizer *)sender;

@end
