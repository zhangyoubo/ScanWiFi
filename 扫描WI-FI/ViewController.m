//
//  ViewController.m
//  扫描WI-FI
//
//  Created by 张友波 on 16/8/8.
//  Copyright © 2016年 张友波. All rights reserved.
//

#import "ViewController.h"

#import <SystemConfiguration/CaptiveNetwork.h>

@interface ViewController ()

@property(nonnull,strong)UIButton *fetchBtn;
@property(nonnull,strong)UITextField *passwordField;
@property(nonnull,strong)UILabel *SSIDInfoLable;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initSubView];

    [self fetchSSIDInfo];
    
}

-(void)initSubView
{
    _fetchBtn=[[UIButton alloc] initWithFrame:CGRectMake((KScreenWidth-200)/2, 40, 200, 40)];
    [_fetchBtn setTitle:@"获取已连接的WI-FI" forState:UIControlStateNormal];
   
    [_fetchBtn addTarget:self action:@selector(tapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [_fetchBtn setBackgroundColor:[UIColor grayColor]];
    
    _SSIDInfoLable=[[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth-300)/2, 100, 300, 40)];
    _SSIDInfoLable.textAlignment=NSTextAlignmentCenter;
    
    _passwordField=[[UITextField alloc] initWithFrame:CGRectMake((KScreenWidth-300)/2, 160, 300, 40)];
    _passwordField.placeholder=@"请输入当前已连接WI-FI的密码";
    _passwordField.textAlignment=NSTextAlignmentCenter;
   // [_passwordField setBackgroundColor:[UIColor grayColor]];
    _passwordField.borderStyle=UITextBorderStyleRoundedRect;
    
    [self.view addSubview:_fetchBtn];
    [self.view addSubview:_SSIDInfoLable];
    [self.view addSubview:_passwordField];
    
}

-(void)tapped:(UIButton *)sender{
    NSDictionary *dict= [self fetchSSIDInfo];
    
    _SSIDInfoLable.text=[NSString stringWithFormat:@"当前WIFI-SSID:%@",[dict objectForKey:@"SSID"]];
}

// 只能获取当前的SSID
- (id)fetchSSIDInfo
{
    NSString *currentSSID = @"";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil){
        NSDictionary* myDict = (__bridge NSDictionary *) CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict!=nil){
            currentSSID=[myDict valueForKey:@"SSID"];
        } else {
            currentSSID=@"<<NONE>>";
        }
    } else {
        currentSSID=@"<<NONE>>";
    }
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSLog(@"%s: Supported interfaces: %@", __func__, ifs);
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((CFStringRef)CFBridgingRetain(ifnam));
        if (info && [info count]) {
            break;
        }
    }
    
    NSLog(@"wifi info %@",info);
    
    return info;
}

/*
{
    BSSID = "0:7:26:19:6d:5c";   无线AP的MAC地址
    SSID = Lianyun;              无线AP的名称(服务集标识)
    SSIDDATA = <4c69616e 79756e>;
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
