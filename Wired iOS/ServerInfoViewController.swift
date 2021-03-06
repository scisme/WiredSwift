//
//  ServerInfoViewController.swift
//  Wired iOS
//
//  Created by Rafael Warnault on 01/04/2020.
//  Copyright © 2020 Read-Write. All rights reserved.
//

import UIKit
import WiredSwift_iOS
import MessageKit


class ServerInfoViewController: UITableViewController {
    var users:[UserInfo] = []
    
    
    // MARK: -
    override func viewDidLoad() {
        
        super.viewDidLoad()

        updateView()
    }
    
    
    func updateView() {
        self.tableView.reloadData()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Disconnect", comment: "Disconnect Bar Button"), style: .done, target: self, action: #selector(disconnect))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.red
    }
    
    
    // MARK: -
    
    var connection: Connection? {
        didSet {
            // Update the view.
            if let c = self.connection {
                if c.isConnected() {
                    self.navigationItem.title = self.connection?.serverInfo.serverName
                    
                    self.tableView.reloadData()
                    
                    updateView()
                }
            }
        }
    }
    
    
    @objc func disconnect() {
        if self.connection != nil && self.connection?.isConnected() == true {
            let alertController = UIAlertController(
                title: NSLocalizedString("Warning", comment: "Disconnect Alert Title"),
                message: NSLocalizedString("Are you sure you want to disconnect?", comment: "Disconnect Alert Message"),
                preferredStyle: .alert)
        
            alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Disconnect Alert Cancel Button"), style: .default))
            alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Disconnect Alert OK Button"), style: .default) { (action) in
                self.connection?.disconnect()
                
                self.navigationController?.popToRootViewController(animated: true)
            })
            
            self.present(alertController, animated: true) { }
        }
    }
}
    
    // MARK: -
 
extension ServerInfoViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.connection == nil || self.connection?.isConnected() == false {
            return 0
        }
        
        return 3
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else if section == 1 {
            return 1
        }
        
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("Server Info", comment: "Server Info Table Header")
        }
        else if section == 1 {
            return NSLocalizedString("Connection", comment: "Connection Table Header")
        }
        
        return NSLocalizedString("Connected Users", comment: "Connected Users Table Header")
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel!.lineBreakMode = .byWordWrapping
                cell.textLabel!.numberOfLines = 0
                cell.textLabel!.text = self.connection!.serverInfo.serverDescription
            }
            else if indexPath.row == 1 {
                cell.textLabel!.lineBreakMode = .byWordWrapping
                cell.textLabel!.numberOfLines = 0
                cell.textLabel!.text = "\(self.connection!.serverInfo.applicationName!) \(self.connection!.serverInfo.applicationVersion!) on \(self.connection!.serverInfo.osName!) \(self.connection!.serverInfo.osVersion!) (\(self.connection!.serverInfo.arch!))"
            }

        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                cell.textLabel!.text = "Protocol \(self.connection!.socket.remoteName!) \(self.connection!.socket.remoteVersion!)"
            }
        } else if indexPath.section == 2 {
            let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserTableViewCell
            
            let user = users[indexPath.row]
            userCell?.nickLabel!.text = user.nick
            userCell?.statusLabel!.text = user.status
            
            if user.idle! {
                userCell?.nickLabel?.alpha = 0.5
                userCell?.imageView?.alpha = 0.5
            } else {
                userCell?.nickLabel?.alpha = 1.0
                userCell?.imageView?.alpha = 1.0
            }
            
            if let base64ImageString = user.icon?.base64EncodedData() {
                if let data = Data(base64Encoded: base64ImageString, options: .ignoreUnknownCharacters) {
                    if let image = UIImage(data: data)?.scale(with: CGSize(width: 32.0, height: 32.0)) {
                        userCell?.imageView?.image = image
                    }
                }
            }
            
            return userCell ?? cell
        }
        
        
        
        return cell
    }
}
