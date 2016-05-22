//
//  RegisterViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/5/22.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "RegisterViewController.h"
#import "ServerCommunicator.h"

@interface RegisterViewController ()<UITextFieldDelegate, ServerCommunicatorDelegate>
{
    ServerCommunicator *_serverCommunicator;
}

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIView *registerBackView;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBackLoginVC:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doRegisterActions:(id)sender {
    if (!_serverCommunicator) {
        _serverCommunicator = [[ServerCommunicator alloc] init];
    }
    [_serverCommunicator prepare:self loadingInView:self.view];
    [_serverCommunicator registerWithUsername:_usernameTextField.text
                                     password:_passwordTextField.text];
    [self handleRequestCompletion:nil];
}

#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_usernameTextField]) {
        [_passwordTextField becomeFirstResponder];
    } else if ([textField isEqual:_passwordTextField]) {
        [self doRegisterActions:nil];
    }
    return YES;
}

#pragma mark -ServerCommunicatorDelegate

- (void)handleRequestFail:(ASIHTTPRequest*)request {
}

- (void)handleRequestCompletion:(ASIHTTPRequest*)request {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.didRegisterCompleted) {
            self.didRegisterCompleted(_usernameTextField.text, _passwordTextField.text);
        }
    }];
}

@end
