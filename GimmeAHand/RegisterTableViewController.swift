//
//  RegisterTableViewController.swift
//  GimmeAHand
//
//  Created by Chengyongping Lu on 3/19/21.
//

import UIKit

class RegisterTableViewController: UITableViewController {
    
    static let communitySection = 2
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet weak var addCommunityButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var selectedCommunities: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RegisterCommunityTableViewCell")
        
        [emailTextField, firstNameTextField, lastNameTextField, mobileTextField, passwordTextField, confirmTextField].forEach { (textField) in
            textField?.delegate = self
        }
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        guard sender == registerButton else {
            debugPrint("Invalid Button!")
            return
        }
        register()
    }
    
    func register() {
        debugPrint("Register!!")
    }
    
    @IBAction func addCommunityAction(_ sender: UIButton) {
        let communityViewController = CommunitySearchTableViewController.embeddedInNavigationController(self)
        present(communityViewController, animated: true)
    }
    
    private func isCommunityIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section == RegisterTableViewController.communitySection && indexPath.row > 0
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == RegisterTableViewController.communitySection {
            return 1 + selectedCommunities.count
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isCommunityIndexPath(indexPath) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterCommunityTableViewCell", for: indexPath)
            cell.textLabel?.text = selectedCommunities[indexPath.row - 1]
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if isCommunityIndexPath(indexPath) {
            return super.tableView(tableView, indentationLevelForRowAt: IndexPath(row: 0, section: RegisterTableViewController.communitySection))
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if isCommunityIndexPath(indexPath) {
            selectedCommunities.remove(at: indexPath.row - 1)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if isCommunityIndexPath(indexPath) {
            return UITableViewCell.EditingStyle.delete
        } else {
            return super.tableView(tableView, editingStyleForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return isCommunityIndexPath(indexPath)
    }
    
}

extension RegisterTableViewController: CommunitySearchTableViewControllerDelegate {
    
    func didSelectCommunity(_ community: String) {
        selectedCommunities.append(community)
        tableView.reloadData()
    }
    
}

extension RegisterTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            emailTextField.resignFirstResponder()
            firstNameTextField.becomeFirstResponder()
        } else if textField == firstNameTextField {
            firstNameTextField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            lastNameTextField.resignFirstResponder()
            mobileTextField.becomeFirstResponder()
        } else if textField == mobileTextField {
            mobileTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            confirmTextField.becomeFirstResponder()
        } else {
            confirmTextField.resignFirstResponder()
        }
        return true
    }
    
}