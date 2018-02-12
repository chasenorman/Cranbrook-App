//
//  ViewController.swift
//  Cranbrook
//
//  Created by Chase Norman on 8/28/17.
//  Copyright © 2017 Chase Norman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var homework: [[String:Any]] = [];
    
    @IBOutlet weak var tableView: UITableView!
    
    let readDate = DateFormatter();
    
    @IBOutlet weak var dateLabel: UILabel!
    
    var selected: Date = Date();
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self;
        tableView.dataSource = self;
        readDate.dateFormat = "M'/'d'/'y";
        
        self.dateLabel.text = self.readDate.string(from:self.selected);
        
        if UserDefaults.standard.string(forKey:"token") != nil{
            loginSuccess();
        }
        else if let username = UserDefaults.standard.string(forKey: "username"), let password = UserDefaults.standard.string(forKey: "password"){
            LoginController.login(username: username, password: password, completionHandler: loginSuccess, errorHandler: loginFailed)
        }
        else{
            performSegue(withIdentifier: "login", sender: nil)
        }
    
        super.viewDidLoad()
    }
    
    func loginFailed(){
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    func loginSuccess(){
        getHomework(start: selected, end: selected);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        selected = Calendar.current.date(byAdding: .day, value: -1, to: selected)!;
        dateChanged();
    }
    
    @IBAction func forwardButtonPressed(_ sender: UIButton) {
        selected = Calendar.current.date(byAdding: .day, value: 1, to: selected)!
        dateChanged();
    }
    
    func getHomework(start: Date, end: Date) {
        let formatDate = DateFormatter();
        formatDate.dateFormat = "M'%2F'd'%2F'y";
        
        let urlString = "https://cranbrook.myschoolapp.com/api/DataDirect/AssignmentCenterAssignments/?format=json&filter=1&dateStart=\(formatDate.string(from:start))&dateEnd=\(formatDate.string(from: end))&persona=2&statusList=&sectionList=";
        var request = URLRequest(url: URL(string: urlString)!);
        request.httpShouldHandleCookies = true;
        request.httpMethod = "GET";
        request.setValue("t=\(UserDefaults.standard.string(forKey:"token")!)", forHTTPHeaderField: "cookie");
        
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    let test = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)! as String;
                    let formattedString = "{\"homework\":\(test)}";
                    do{
                        try self.homework = (JSONSerialization.jsonObject(with: formattedString.data(using: .utf8)!, options: []) as! [String : [[String : Any]]])["homework"]!;
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData();
                        }
                    }catch{}
                }
                else{
                    LoginController.login(username: UserDefaults.standard.string(forKey: "username")!, password: UserDefaults.standard.string(forKey: "password")!, completionHandler: self.loginSuccess, errorHandler: self.loginFailed);
                }
            }else{
                LoginController.login(username: UserDefaults.standard.string(forKey: "username")!, password: UserDefaults.standard.string(forKey: "password")!, completionHandler: self.loginSuccess, errorHandler: self.loginFailed);
            }
        }
        task.resume();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homework.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        cell.textLabel!.text = String(htmlEncodedString: (homework[indexPath.row]["short_description"]! as AnyObject).description);
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func dateChanged(){
        DispatchQueue.main.async{
            self.dateLabel.text = self.readDate.string(from:self.selected);
            self.getHomework(start: self.selected, end: self.selected)
        }
    }
}

extension String {
    init?(htmlEncodedString: String) {
        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey.characterEncoding : String.Encoding.utf8.rawValue
        ]

        if let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil){
            self.init(attributedString.string)
        }
        else {
            return nil
        }
    }
}

enum HTTPError : Error {
    case MalformedResponse
    case FailedRequest
}


