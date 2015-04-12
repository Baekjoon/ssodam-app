//
//  ViewController.swift
//  ssodam
//
//  Created by Baekjoon Choi on 4/12/15.
//  Copyright (c) 2015 Baekjoon Choi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var loginAlertController  = UIAlertController(title: "로그인", message: nil, preferredStyle: UIAlertControllerStyle.Alert);
        loginAlertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "아이디";
        })
        loginAlertController.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "비밀번호";
            textField.secureTextEntry = true;
        })
        loginAlertController.addAction(UIAlertAction(title: "로그인", style: UIAlertActionStyle.Default, handler: { (alertAction) -> Void in
            if let textFields = loginAlertController.textFields as? [UITextField] {
                var username = textFields[0].text;
                var password = textFields[1].text;
                self.login(username: username, password: password);
            }
        }))
        presentViewController(loginAlertController, animated: true, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func login(#username: String, password: String) {
        println("로그인 시작: \(username)");
        
        var manager = AFHTTPRequestOperationManager();
        
        var params: [String: AnyObject] = ["id": username, "pass": password, "auto": false];
        
        manager.POST("https://www.ssodam.com/loginCheck", parameters: params, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            println("response Object: \(responseObject)");
            
            var d = responseObject as! [String: AnyObject]
            if let t = d["type"] as? Int {
                if t == 0 { // 로그인 실패
                    println("로그인 실패");
                    println(d["msg"]!);
                } else {
                    self.loginSuccess();
                }
            }
            
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            
            println("\(error.description)");
            
        }
    }
    func loginSuccess() {
        var request = NSURLRequest(URL: NSURL(string: "https://www.ssodam.com")!)
        webView.loadRequest(request)
    }
    
    @IBAction func logoutClicked(sender: UIBarButtonItem) {
        webView.stringByEvaluatingJavaScriptFromString("location.href=\"/logout\"");
    }
    
}

