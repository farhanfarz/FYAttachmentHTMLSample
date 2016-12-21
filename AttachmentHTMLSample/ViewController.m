//
//  ViewController.m
//  AttachmentHTMLSample
//
//  Created by Farhan Yousuf on 08/06/16.
//  Copyright © 2016 July Systems Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "NSAttributedString+HTMLFromRange.h"

@interface ViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    UIImagePickerController *_imagePicker;
    
    NSMutableAttributedString *attributedString;
}
@property (nonatomic, strong) NSMutableArray *arrayBody;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSMutableAttributedString *attributedMailBodyInternal;
@property (nonatomic, strong) NSMutableAttributedString *attributedMailBodyTextView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    _arrayBody = [NSMutableArray new];
//    
//    UIImage *image = [UIImage imageNamed:@"Arrow"];
//
//    [_arrayBody addObject:@{@"text":@"Spectacular Arrow",@"attachment":image}];
//    
//    NSLog(@"Base64 : %@",[_arrayBody htmlBody]);
//    
//    [_webView loadHTMLString:[_arrayBody htmlBody] baseURL:nil];
    
    attributedString = [[NSMutableAttributedString alloc] initWithString:@"like after"];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:14] range:NSMakeRange(0, 4)];

    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:@"Arrow"];
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [attributedString replaceCharactersInRange:NSMakeRange(4, 1) withAttributedString:attrStringWithImage];
    
}

#pragma mark - Photo Library Action
- (IBAction)addImagePressed:(id)sender {
    
    
}
- (IBAction)sendPressed:(id)sender {

    NSString *htmlString = [attributedString HTMLFromRange:NSMakeRange(0, attributedString.length)];
    
    [_textView setText:htmlString];

    [_webView loadHTMLString:htmlString baseURL:nil];
    
}

/*
- (void)openPhotoLibrary{
    
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
    }
    _imagePicker.delegate = self;
    _imagePicker.allowsEditing = YES;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:_imagePicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];

    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
