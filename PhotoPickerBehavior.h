//
//  PhotoPickerBehavior.h
//  WeightControl
//
//  Created by Dmitry Savin on 8/6/14.
//  Copyright (c) 2014 Bright Solutions. All rights reserved.
//

@import Foundation;

@protocol PhotoPickerBehaviorDelegate;
@protocol ScreenPresenter;


/** This class encapsulate picking of photo behavior. */
@interface PhotoPickerBehavior : NSObject

/** Outlet to manage image view inside @c PhotoPickerBehavior class. */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

/** Delegate of @c PhotoPickerBehavior class. */
@property (weak, nonatomic) IBOutlet id<PhotoPickerBehaviorDelegate> delegate;

/** Gesture recognizer handle selection of image view. */
@property (strong, nonatomic) UIGestureRecognizer *gestureRecognizer;

/** Size of the longest side of the image to resize to. If it is 0.0 the original image will be used. */
@property (nonatomic) CGFloat imageSize;

@end


/** Gives the opportunity to objects define behavior after image was selected. */
@protocol PhotoPickerBehaviorDelegate <NSObject>

- (void)photoPickerBehavior: (PhotoPickerBehavior *)photoPicker didSelectImage: (UIImage *)image;

- (void)photoPickerBehavior: (PhotoPickerBehavior *)photoPicker needPresentImagePickerController: (UIImagePickerController *)picker;

- (void)photoPickerBehavior: (PhotoPickerBehavior *)photoPicker needHideImagePickerController: (UIImagePickerController *)picker;

@end
