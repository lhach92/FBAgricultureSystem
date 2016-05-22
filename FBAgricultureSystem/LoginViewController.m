//
//  LoginViewController.m
//  FBAgricultureSystem
//
//  Created by lvhuan on 16/1/13.
//  Copyright © 2016年 fubin. All rights reserved.
//

#import "LoginViewController.h"
#import "ServerCommunicator.h"
#import "RegisterViewController.h"

@interface LoginViewController ()<UITextFieldDelegate, ServerCommunicatorDelegate>
{
    ServerCommunicator *_serverCommunicator;
    CGPoint _loginBackViewCenter;
}

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIView *loginBackView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _loginBackViewCenter = _loginBackView.center;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doLoginActions:(id)sender {
//    if (!_serverCommunicator) {
//        _serverCommunicator = [[ServerCommunicator alloc] init];
//    }
//    [_serverCommunicator prepare:self loadingInView:self.view];
//    [_serverCommunicator loginWithUsername:_userNameTextField.text
//                                  password:_passwordTextField.text];
    [self handleRequestCompletion:nil];
}

- (IBAction)goRegisterViewController:(id)sender {
    [self performSegueWithIdentifier:@"gotoRegister" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    RegisterViewController *vc = segue.destinationViewController;
    vc.didRegisterCompleted = ^(NSString *userName, NSString *password) {
        [weakSelf handleRegisterCompleted:userName
                                 password:password];
    };
}

- (void)handleRegisterCompleted:(NSString *)userName
                       password:(NSString *)password {
    _userNameTextField.text = userName;
    _passwordTextField.text = password;
    [self doLoginActions:nil];
}

#pragma mark -UITextFieldDelegate 

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_userNameTextField]) {
        [_passwordTextField becomeFirstResponder];  
    } else if ([textField isEqual:_passwordTextField]) {
        [self doLoginActions:nil];
    }
    return YES;
}

#pragma mark -ServerCommunicatorDelegate

- (void)handleRequestFail:(ASIHTTPRequest*)request {
}

- (void)handleRequestCompletion:(ASIHTTPRequest*)request {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLogined"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
