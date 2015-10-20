//
//  ViewController.m
//  PicOnPic
//
//  Created by Adam Nagy on 20/10/2012.
//  Copyright (c) 2012 Adam Nagy. All rights reserved.
//

#import "ViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()

@end

@implementation ViewController

@synthesize popoverController;
@synthesize overlayImageView;

- (void)viewDidLoad
{
  NSLog(@"viewDidLoad");
  [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
  NSLog(@"didReceiveMemoryWarning");
  [super didReceiveMemoryWarning];
}

- (IBAction)startCamera:(id)sender
{
  NSLog(@"startCamera");

  if (popoverController)
  {
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;    
    return;
  }
  
  if ([UIImagePickerController isSourceTypeAvailable:
       UIImagePickerControllerSourceTypeCamera])
  {
    UIImagePickerController * imagePicker =
    [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType =
    UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = [NSArray arrayWithObjects:
                              (NSString *) kUTTypeImage,
                              nil];
    imagePicker.allowsEditing = NO;
    
    
    [self presentViewController:imagePicker
                       animated:YES completion:nil];
  }
}

- (IBAction)findPic:(id)sender
{
  NSLog(@"findPic");

  if (popoverController)
  {
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;    
    return;
  }
    
  if ([UIImagePickerController isSourceTypeAvailable:
       UIImagePickerControllerSourceTypeSavedPhotosAlbum])
  {
    UIImagePickerController * imagePicker =
    [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType =
      UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.mediaTypes = [NSArray arrayWithObjects:
                              (NSString *) kUTTypeImage,
                              nil];
    imagePicker.allowsEditing = NO;
    
    popoverController = [[UIPopoverController alloc]
      initWithContentViewController:imagePicker];
    
    popoverController.delegate = self;
    
    [popoverController presentPopoverFromBarButtonItem:sender
      permittedArrowDirections:UIPopoverArrowDirectionUp
      animated:YES];
  }
}

- (void)imagePickerController:
(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  NSLog(@"imagePickerController");
  
  [picker dismissViewControllerAnimated:YES completion:nil];
  
  UIImage * image =
    [info objectForKey:UIImagePickerControllerOriginalImage];

  // If it's a picture selection
  if (popoverController)
  {
    [popoverController dismissPopoverAnimated:YES];
    popoverController = nil;
  
    if (overlayImageView)
      [overlayImageView removeFromSuperview];
    
    overlayImageView = [[UIImageView alloc] initWithImage:image];

    [self.imageView addSubview:overlayImageView];
  }
  // If it's taken by the camera
  else
  {
    [popoverController dismissPopoverAnimated:YES];
      popoverController = nil;
    [self.imageView setImage:image];
  }
}

- (BOOL)popoverControllerShouldDismissPopover:
(UIPopoverController *)popoverController
{
  NSLog(@"popoverControllerShouldDismissPopover");
  return YES;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
  NSLog(@"popoverControllerDidDismissPopover");
  self.popoverController = nil;
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)sender
{
  NSLog(@"pinch");

  static CGAffineTransform origTr;
  if (sender.state == UIGestureRecognizerStateBegan)
  {
    origTr = overlayImageView.transform;
  }
  else if (sender.state == UIGestureRecognizerStateChanged)
  {
    CGFloat scale = [sender scale];
    
    CGAffineTransform tr =
      CGAffineTransformConcat(
        origTr,
        CGAffineTransformMakeScale(scale, scale));
    
    [self.overlayImageView setTransform:tr];
  }
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender
{
  NSLog(@"pan");

  static CGPoint prevPt;
  if (sender.state == UIGestureRecognizerStateBegan)
  {
    prevPt = [sender locationInView:self.imageView];
  }
  else if (sender.state == UIGestureRecognizerStateChanged)
  {
    CGPoint pt = [sender locationInView:self.imageView];
    
    CGAffineTransform tr =
      CGAffineTransformMakeTranslation(
        pt.x - prevPt.x,
        pt.y - prevPt.y);
    
    CGPoint cp =
      CGPointApplyAffineTransform(self.overlayImageView.center, tr);
    
    [self.overlayImageView setCenter:cp];
    
    prevPt = pt;
  }
}

- (IBAction)rotate:(UIRotationGestureRecognizer *)sender
{
  NSLog(@"rotate");

  static CGAffineTransform origTr;
  if (sender.state == UIGestureRecognizerStateBegan)
  {
    origTr = overlayImageView.transform;
  }
  else if (sender.state == UIGestureRecognizerStateChanged)
  {
    CGFloat rotation = [sender rotation];
    
    // Scale
    CGAffineTransform tr =
      CGAffineTransformConcat(
        origTr,
        CGAffineTransformMakeRotation(rotation));
    
    [self.overlayImageView setTransform:tr];
  }
}
@end
