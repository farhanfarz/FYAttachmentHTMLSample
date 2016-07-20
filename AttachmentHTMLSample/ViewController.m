//
//  ViewController.m
//  AttachmentHTMLSample
//
//  Created by Farhan Yousuf on 08/06/16.
//  Copyright © 2016 July Systems Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+NSArray_HTMLBody.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray *arrayBody;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _arrayBody = [NSMutableArray new];
    
    UIImage *image = [UIImage imageNamed:@"Arrow"];

    [_arrayBody addObject:@{@"text":@"Spectacular Arrow",@"attachment":image}];
    
    NSLog(@"Base64 : %@",[_arrayBody htmlBody]);
    
    [_webView loadHTMLString:[_arrayBody htmlBody] baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
