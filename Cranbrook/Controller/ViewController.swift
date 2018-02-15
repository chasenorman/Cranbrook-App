//
//  ViewController.swift
//  Cranbrook
//
//  Created by Chase Norman on 8/28/17.
//  Edited by Aziz Zaynutdinov.
//  Copyright © 2017 Chase Norman. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var homework: [[String:Any]] = [];
    var finished: [Bool] = [];
    
    @IBOutlet weak var tableView: UITableView!
    
    let formatDate = DateFormatter();
    let readDate = DateFormatter();
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var selected: Date = Date();
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.delegate = self;
        tableView.dataSource = self;
        readDate.dateFormat = "EEEE, MMM d";
        formatDate.dateFormat = "M'%2F'd'%2F'y";
        loading.hidesWhenStopped = true;
        
        self.dateLabel.text = self.readDate.string(from:self.selected);
        
        if UserDefaults.standard.string(forKey:"token") != nil{
            loginSuccess();
        }
        else if let username = UserDefaults.standard.string(forKey: "username"), let password = UserDefaults.standard.string(forKey: "password"){
            LoginController.login(username: username, password: password, completionHandler: loginSuccess, failureHandler: loginFailed, networkErrorHandler: networkError)
        }
        else{
            performSegue(withIdentifier: "login", sender: nil)
        }
    }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            let refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(updateHomework), for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
    
    @objc func updateHomework(refreshControl: UIRefreshControl) {
        
        getHomework(start: self.selected, end: self.selected)
        refreshControl.endRefreshing()
    }
    
    func networkError(){
        performSegue(withIdentifier: "networkError", sender: nil)
    }
    
    func loginFailed(){
        performSegue(withIdentifier: "login", sender: nil)
    }
    
    func loginSuccess(){
        dateChanged();
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
        if Reachability.isConnectedToNetwork() == false{
            networkError()
        }
        else {
        print("Refresh worked!")
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
                        self.finished = [Bool](repeating: false, count: self.homework.count);
                        DispatchQueue.main.async {
                            self.loading.stopAnimating();
                            self.tableView.reloadData();
                        }
                    }catch{}
                }
                else{
                    LoginController.login(username: UserDefaults.standard.string(forKey: "username")!, password: UserDefaults.standard.string(forKey: "password")!, completionHandler: self.loginSuccess, failureHandler: self.loginFailed, networkErrorHandler: self.networkError);
                }
            }else{
                LoginController.login(username: UserDefaults.standard.string(forKey: "username")!, password: UserDefaults.standard.string(forKey: "password")!, completionHandler: self.loginSuccess, failureHandler: self.loginFailed, networkErrorHandler: self.networkError);
            }
        }
        task.resume();
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homework.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeworkCell;
        cell.homework(homework[indexPath.row]);
        if finished[indexPath.row] {
            cell.backgroundColor = UIColor(red: 92/255.0, green: 221/255.0, blue: 103/255.0, alpha: 1)
        }
        else{
            cell.backgroundColor = UIColor.white;
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        finished[indexPath.row] = !finished[indexPath.row];
        DispatchQueue.main.async{
            self.tableView.reloadData();
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func dateChanged(){
        DispatchQueue.main.async{
            self.homework = [];
            self.loading.startAnimating();
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

