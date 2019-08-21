//
//  LogController.swift
//  refreshing-stomach
//
//  Created by Jie Wu on 2019/08/16.
//  Copyright © 2019 Lindelin. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class LogController: UITableViewController {
    
    var logs: [Log] = []
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
    }
    
    @objc func loadData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Do any additional setup after loading the view.
        let logFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Log")
        do {
            let fetchedLogs = try context.fetch(logFetch) as! [Log]
            self.logs = fetchedLogs
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            
            do {
                var array: [[String: Any]] = []
                for log in fetchedLogs {
                    array.append([
                        "id": log.id?.uuidString as Any,
                        "type": log.type as Any,
                        "created_at": log.createdAt?.description as Any
                        ])
                }
                let ref = self.db.collection("users").document(Auth.auth().currentUser!.uid)
                ref.setData(["logs": array], merge: true) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref.documentID)")
                    }
                }
            } catch {
                print("Error fetching data from CoreData")
            }
        } catch {
            fatalError("Failed to fetch log: \(error)")
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return logs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestLogCell", for: indexPath)

        cell.textLabel?.text = logs[indexPath.row].createdAt?.description

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
