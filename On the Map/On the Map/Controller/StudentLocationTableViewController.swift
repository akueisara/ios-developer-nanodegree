//
//  TableViewController.swift
//  On the Map
//
//  Created by Kuei-Jung Hu on 2018/4/25.
//  Copyright © 2018 Kuei-Jung Hu. All rights reserved.
//

import UIKit

// MARK: - TableViewController  : UIViewController

class StudentLocationTableViewController: UIViewController {
    
    // MARK: Properties
    
    var students: [UdacityStudent] = [UdacityStudent]()
    
    // MARK: Outlets
    
    @IBOutlet var studentsTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadTableView()
    }
    
    func loadTableView() {
        UdacityClient.sharedInstance().getStudentLocations() { (students, error) in
            if let students = students {
                self.students = students
                DispatchQueue.main.async {
                    self.studentsTableView.reloadData()
                }
            } else {
                print(error ?? "empty error")
            }
        }
    }
    
    // MARK: Logout
    
    @IBAction func logout(_ sender: Any) {
        dismiss(animated: true, completion:{
            UdacityClient.sharedInstance().logout()
        })
    }
}

// MARK: - TableViewController: UITableViewDelegate, UITableViewDataSource

extension StudentLocationTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentLocationTableViewCell"
        let student = students[(indexPath as NSIndexPath).row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! StudentLocationTableViewCell
        
        /* Set cell defaults */
        cell.studentName?.text = "\(student.firstName) \(student.lastName)"
        cell.studentMediaURL?.text = student.mediaURL

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if students.count > 100 {
            return 100
        } else {
            return students.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[(indexPath as NSIndexPath).row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        let app = UIApplication.shared
        if UdacityClient.sharedInstance().checkURL(student.mediaURL!){
            app.open(URL(string: student.mediaURL!)!)
        } else {
            UdacityClient.sharedInstance().displayAlert(self, title: "", message: ErrorMessage.InvalidLinkTitle)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 65.0
    }
}
