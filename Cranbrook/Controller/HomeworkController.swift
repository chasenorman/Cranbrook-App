//
//  ViewController.swift
//  Cranbrook
//
//  Created by Chase Norman on 8/28/17.
//  Edited by Aziz Zaynutdinov.
//  Copyright © 2017 Chase Norman. All rights reserved.
//

import UIKit
import BRYXBanner

class HomeworkController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Declare all global variables and constants.
    var homework: [Homework] = []
    var finished: [UIColor] = []
    let formatDate = DateFormatter()
    let readDate = DateFormatter()
    var selected: Date = Date()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var noHomeworkLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.string(forKey:"token") != nil{
            dateChanged();
        }
        else{
            self.tabBarController!.performSegue(withIdentifier: "login", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateHomework), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        tableView.delegate = self;
        tableView.dataSource = self;
        readDate.dateFormat = "EEEE, MMM d";
        formatDate.dateFormat = "M'%2F'd'%2F'y";
        loading.hidesWhenStopped = true;
        
        self.dateLabel.text = self.readDate.string(from:self.selected);
        noHomeworkLabel.isHidden = true;
    }
    
    @objc func updateHomework(refreshControl: UIRefreshControl) {
        getHomework(start: self.selected, end: self.selected)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?{
        
        let moreRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Complete", handler:{action, indexpath in
            DispatchQueue.main.async{
                if(self.finished[indexPath.row] != UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0)){
                    self.finished[indexPath.row] = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
                }
                else{
                    self.finished[indexPath.row] = UIColor.white;
                }
                self.tableView.reloadData();
            }
        });
        moreRowAction.backgroundColor = UIColor(red: 0.298, green: 0.851, blue: 0.3922, alpha: 1.0);
        
        let toDoRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "To-Do", handler:{action, indexpath in
            DispatchQueue.main.async{
                if(self.finished[indexPath.row] != UIColor.orange){
                    self.finished[indexPath.row] = UIColor.orange;
                }
                else{
                    self.finished[indexPath.row] = UIColor.white;
                }
                self.tableView.reloadData();
            }
        });
        toDoRowAction.backgroundColor = UIColor.orange;
        
        return [toDoRowAction, moreRowAction];
    }
    
    func networkError(){
        let errorBanner = Banner(title: "Error", subtitle: "You are offline.", image: nil, backgroundColor: UIColor.red, didTapBlock: nil)
        errorBanner.dismissesOnTap = true
        errorBanner.show(duration: 3.0)
    }
    
    func loginFailed(){
        self.tabBarController!.performSegue(withIdentifier: "login", sender: nil)
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
            return;
        }
    
        let urlString = "https://cranbrook.myschoolapp.com/api/DataDirect/AssignmentCenterAssignments/?format=json&filter=1&dateStart=\(formatDate.string(from:start))&dateEnd=\(formatDate.string(from: end))&persona=2&statusList=&sectionList=";
        var request = URLRequest(url: URL(string: urlString)!);
        request.httpShouldHandleCookies = true;
        request.httpMethod = "GET";
        request.setValue("t=\(UserDefaults.standard.string(forKey:"token")!)", forHTTPHeaderField: "cookie");
            
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200){
                    do{try self.homework = JSONDecoder().decode([Homework].self, from: data!);}catch{}
                    self.finished = [UIColor](repeating: UIColor.white, count: self.homework.count);
                    DispatchQueue.main.async {
                        self.loading.stopAnimating();
                        self.tableView.reloadData();
                        self.noHomeworkLabel.isHidden = self.homework.count == 0 ? false : true;
                        self.tableView.refreshControl!.endRefreshing();
                    }
                }else{
                    LoginController.login(completionHandler: self.loginSuccess, loginErrorHandler: self.loginFailed, networkErrorHandler: self.networkError);
                }
            }
        }.resume();
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homework.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeworkCell;
        cell.homework(homework[indexPath.row]);
        cell.backgroundColor = finished[indexPath.row];
        return cell
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



