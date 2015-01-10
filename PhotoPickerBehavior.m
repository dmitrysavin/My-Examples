//
//  PhotoPickerBehavior.m
//  WeightControl
//
//  Created by Dmitry Savin on 8/6/14.
//  Copyright (c) 2014 Bright Solutions. All rights reserved.
//

#import "PhotoPickerBehavior.h"
#import "UIImage+ScaleAndResize.h"
@import MobileCoreServices;

@interface PhotoPickerBehavior () <
    UIActionSheetDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
>

@end


@implementation PhotoPickerBehavior

#pragma mark - Object life cycle -

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(imageViewTapped:)];
    
    return self;
}


#pragma mark - Interface -

- (void)setImageView: (UIImageView *)imageView
{
    if (_imageView) {
        [_imageView removeGestureRecognizer: self.gestureRecognizer];
    }
    
    _imageView = imageView;
    _imageView.clipsToBounds = YES;
    [_imageView addGestureRecognizer: self.gestureRecognizer];
}


#pragma mark - Actions -

- (void)imageViewTapped: (id)sender
{
    UIActionSheet *actionSheet = [UIActionSheet new];
    actionSheet.title = NSLocalizedString( @"ChoosePhotoSource", @"Please choose the photo source" );
    actionSheet.delegate = self;

    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        [actionSheet addButtonWithTitle: NSLocalizedString( @"Camera", @"Camera" )];
    }
    
    [actionSheet addButtonWithTitle: NSLocalizedString( @"SavedPhotos", @"Saved photos")];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle: NSLocalizedString( @"Cancel", @"Cancel" )];
    
    [actionSheet showFromRect: self.imageView.bounds inView: self.imageView animated: YES];
}


#pragma mark - Delegates -

#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    UIImagePickerController *pickerViewController = [UIImagePickerController new];
    pickerViewController.delegate = self;
    
    if ([[actionSheet buttonTitleAtIndex: buttonIndex] isEqualToString: NSLocalizedString( @"Camera", @"Camera" )]) {
        pickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        pickerViewController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self.delegate photoPickerBehavior: self needPresentImagePickerController: pickerViewController];
}


#pragma mark UINavigationControllerDelegate

- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info
{
    if (![info[UIImagePickerControllerMediaType] isEqual: (NSString *)kUTTypeImage]) return;

    UIImage *image = info[UIImagePickerControllerOriginalImage];

    if (self.imageSize != 0.0) {
        image = [image brs_imageScaledToConstrainSize: CGSizeMake( self.imageSize, self.imageSize )];
    }

    self.imageView.image = image;
    
    [self.delegate photoPickerBehavior: self didSelectImage: image];
    [self.delegate photoPickerBehavior: self needHideImagePickerController: picker];
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self.delegate photoPickerBehavior: self needHideImagePickerController: picker];
}

@end
