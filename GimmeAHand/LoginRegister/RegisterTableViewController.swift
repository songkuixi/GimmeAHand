//
//  RegisterTableViewController.swift
//  GimmeAHand
//
//  Created by Chengyongping Lu on 3/19/21.
//

import UIKit
import SVProgressHUD

class RegisterTableViewController: AuthenticateTableViewController {
    
    static let communitySection = 2
    static let registerButtonSection = 4
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmTextField: UITextField!
    
    @IBOutlet weak var addCommunityButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var selectedCommunities: [CommunityModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RegisterCommunityTableViewCell")
        
        [emailTextField, firstNameTextField, lastNameTextField, mobileTextField, passwordTextField, confirmTextField].forEach { (textField) in
            textField?.delegate = self
        }
        registerButton.backgroundColor = .lightGray
        registerButton.isEnabled = false
    }
    
    @IBAction func registerAction(_ sender: UIButton) {
        guard sender == registerButton else {
            return
        }
        register()
    }
    
    func register() {
        // Validation
        guard let firstName = firstNameTextField.text, !firstName.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "Enter First Name")
            firstNameTextField.becomeFirstResponder()
            return
        }
        guard let lastName = lastNameTextField.text, !lastName.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "Enter Last Name")
            lastNameTextField.becomeFirstResponder()
            return
        }
        guard let email = emailTextField.text, !email.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "Enter Email")
            emailTextField.becomeFirstResponder()
            return
        }
        guard let phone = mobileTextField.text, !phone.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "Enter Phone")
            mobileTextField.becomeFirstResponder()
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "Enter Password")
            passwordTextField.becomeFirstResponder()
            return
        }
        guard let password2 = confirmTextField.text, !password2.isEmpty else {
            SVProgressHUD.showInfo(withStatus: "Enter Confirm Password")
            confirmTextField.becomeFirstResponder()
            return
        }
        guard password == password2 else {
            SVProgressHUD.showInfo(withStatus: "Passwords don't match")
            return
        }
        
        // Registration
        let newUser = UserModel(firstName, lastName, email, phone, CryptoHelper.encrypt(password))
        UserHelper.shared.addUser(newUser)
        UserHelper.shared.currentUser = newUser
        
        SVProgressHUD.show(withStatus: "Register")
        SVProgressHUD.dismiss(withDelay: GHConstant.kStoryboardTransitionDuration) {
            super.transitionToMain()
        }
    }
    
    @IBAction func addCommunityAction(_ sender: UIButton) {
        let communityViewController = CommunitySearchTableViewController.embeddedInNavigationController(self, .add)
        present(communityViewController, animated: true)
    }
    
    private func isCommunityIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section == RegisterTableViewController.communitySection && indexPath.row > 0
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
            cell.textLabel?.text = selectedCommunities[indexPath.row - 1].name
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 1:
            return GHConstant.kPasswordRuleString
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if isCommunityIndexPath(indexPath) {
            return super.tableView(tableView, indentationLevelForRowAt: IndexPath(row: 0, section: RegisterTableViewController.communitySection))
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == RegisterTableViewController.registerButtonSection ? 50.0 : 44.0
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "privacyPolicySegue" {
            let privacyPolicyViewController = segue.destination as! PrivacyPolicyViewController
            privacyPolicyViewController.delegate = self
        }
    }
}

extension RegisterTableViewController: CommunitySearchTableViewControllerDelegate {
    
    func didSelectCommunity(_ community: CommunityModel) {
        selectedCommunities.append(community)
        tableView.reloadData()
    }
    
}

extension RegisterTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            emailTextField.resignFirstResponder()
            firstNameTextField.becomeFirstResponder()
        case firstNameTextField:
            firstNameTextField.resignFirstResponder()
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            lastNameTextField.resignFirstResponder()
            mobileTextField.becomeFirstResponder()
        case mobileTextField:
            mobileTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            passwordTextField.resignFirstResponder()
            confirmTextField.becomeFirstResponder()
        case confirmTextField:
            confirmTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
}

extension RegisterTableViewController: PrivacyPolicyViewControllerDelegate {
    
    func didReadPrivacyPolicy() {
        registerButton.backgroundColor = .GHTint
        registerButton.isEnabled = true
    }
    
}
