
//
//  FeedBackViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/5/22.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "FeedBackViewController.h"
#import "ServerCommunicator.h"

@interface FeedBackViewController ()<UITextFieldDelegate, ServerCommunicatorDelegate>
{
    ServerCommunicator *_serverCommunicator;
}

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *contenctTextView;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)postFeedBack:(id)sender {
    if (!_serverCommunicator) {
        _serverCommunicator = [[ServerCommunicator alloc] init];
    }
    [_serverCommunicator prepare:self loadingInView:self.view];
    [_serverCommunicator postFeedBackWithTitle:_titleTextField.text
                                         phone:_phoneTextField.text
                                       content:_contenctTextView.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_titleTextField]) {
        [_phoneTextField becomeFirstResponder];
    } else if ([textField isEqual:_phoneTextField]) {
        [_contenctTextView becomeFirstResponder];
    }
    return YES;
}

#pragma mark -ServerCommunicatorDelegate 

- (void)handleRequestFail:(ASIHTTPRequest*)request {
    
}

- (void)handleRequestCompletion:(ASIHTTPRequest*)request {
    
}


@end
