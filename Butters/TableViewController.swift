//
//  TableViewController.swift
//  Butters
//
//  Created by kanj on 14/09/18.
//  Copyright © 2018 kanj. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    //MARK: Properties
    @IBOutlet weak var addButton: UIBarButtonItem!
    let userDefaults = UserDefaults.standard
    var items = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.editButtonItem.title = "Delete"
        self.navigationItem.rightBarButtonItem = self.editButtonItem

        userDefaults.stringArray(forKey: "STUFF")?.forEach({ (it) in
            items.append(it)
        })
        
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setToolbarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.editButtonItem.title = editing ? "Done" : "Delete"
        self.addButton.isEnabled = !editing
    }

    // MARK: Actions

    @IBAction func handleAddClick(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Add", message: "Input stuff to add", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let text = alertController.textFields?[0].text, !text.isEmpty else { return }
            self.addStuff(text: text)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        alertController.addTextField { (_) in }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)

        cell.textLabel?.text = items[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveStuff(stuff: items)
        }
    }

    private func saveStuff(stuff: [String]) {
        userDefaults.set(stuff, forKey: "STUFF")
    }
    
    private func addStuff(text: String) {
        items.append(text)
        saveStuff(stuff: items)
        tableView.reloadData()
    }
    
}