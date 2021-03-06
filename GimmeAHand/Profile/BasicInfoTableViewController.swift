//
//  BasicInfoTableViewController.swift
//  GimmeAHand
//
//  Created by Kuixi Song on 4/23/21.
//

import UIKit

class BasicInfoTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    struct CellPositions {
        struct Section {
            static let photo = 0
            static let email = 0
            static let firstName = 0
            static let lastName = 0
            static let phone = 0
        }
        
        struct Row {
            static let photo = 0
            static let email = 1
            static let firstName = 2
            static let lastName = 3
            static let phone = 4
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var changePasswordBotton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var emailVerifyLabel: UILabel!
    @IBOutlet weak var phoneVerifyLabel: UILabel!
    
    var selectedCommunities: [CommunityModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProfileCommunityTableViewCell")
        
        let currentUser = UserHelper.shared.currentUser
        
        emailLabel.text = currentUser.email
        firstNameLabel.text = currentUser.firstName
        lastNameLabel.text = currentUser.lastName
        phoneLabel.text = currentUser.phone
        avatarImageView.setRoundCorner(avatarImageView.frame.width / 2.0)
        
        // TODO: mock verification labels
        [emailVerifyLabel, phoneVerifyLabel].forEach {
            $0?.text = "Verified"
            $0?.textColor = .GHTint
        }
    }
    
    @IBAction func changePasswordAction(_ sender: UIButton) {
        let ac = UIAlertController(title: "Change Password", message: "Please specify a new password.", preferredStyle: .alert)
        
        ac.addTextField{(passwordText) -> Void in
            passwordText.placeholder = GHConstant.kPasswordRuleString
            passwordText.isSecureTextEntry = true
        }
        
        ac.addTextField{(secondPasswordText) -> Void in
            secondPasswordText.placeholder = "Please confirm your new password."
            secondPasswordText.isSecureTextEntry = true
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        let ac = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            self.logout()
        }))
        present(ac, animated: true)
    }
    
    func logout() {
        UserDefaultsHelper.shared.saveFaceID(false)
        UserHelper.shared.logout()
        UIView.transition(with: UIApplication.shared.windows.first!,
                          duration: GHConstant.kStoryboardTransitionDuration,
                          options: .transitionFlipFromLeft,
                          animations: {
                            UIApplication.shared.windows.first!.rootViewController = UIStoryboard(name: "LoginRegister", bundle: nil).instantiateInitialViewController()
        })
    }
    
    func presentImagePicker(with sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true)
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == CellPositions.Section.photo && indexPath.row == CellPositions.Row.photo {
            return 140.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Unselect the row.
        tableView.deselectRow(at: indexPath, animated: false)
        
        if indexPath.section == CellPositions.Section.photo && indexPath.row == CellPositions.Row.photo {
            let ac = UIAlertController(title: "Edit Photo", message: "How would you like to edit your photo?", preferredStyle: .actionSheet)
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                ac.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
                    self.presentImagePicker(with: .photoLibrary)
                }))
            }
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
                    self.presentImagePicker(with: .camera)
                }))
            }
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            if let popoverPresentationController = ac.popoverPresentationController {
                popoverPresentationController.sourceView = tableView
                popoverPresentationController.sourceRect = avatarImageView.frame
            }
            present(ac, animated: true)
        } else if indexPath.section == CellPositions.Section.email && indexPath.row == CellPositions.Row.email {
            let ac = UIAlertController(title: "Edit Email", message: "Please specify a new email", preferredStyle: .alert)
            
            ac.addTextField { (emailText) -> Void in
                emailText.placeholder = self.emailLabel.text
                emailText.keyboardType = .emailAddress
            }
            
            ac.addTextField { (secondEmailText) -> Void in
                secondEmailText.placeholder = "Please confirm your new email."
                secondEmailText.keyboardType = .emailAddress
            }
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Verify", style: .destructive, handler: { alertAction in
                let newInput = ac.textFields?.first?.text
                self.emailLabel.text = newInput
            }))
            present(ac, animated: true)
        } else if indexPath.section == CellPositions.Section.firstName && indexPath.row == CellPositions.Row.firstName {
            let ac = UIAlertController(title: "Edit First Name", message: "Please specify a new first name.", preferredStyle: .alert)
            
            ac.addTextField{ (firstNameText) -> Void in
                firstNameText.placeholder = self.firstNameLabel.text
            }
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { alertAction in
                let newInput = ac.textFields?.first?.text
                self.firstNameLabel.text = newInput
            }))
            present(ac, animated: true)
        } else if indexPath.section == CellPositions.Section.lastName && indexPath.row == CellPositions.Row.lastName {
            let ac = UIAlertController(title: "Edit Last Name", message: "Please specify a new last name.", preferredStyle: .alert)
            
            ac.addTextField{ (lastNameText) -> Void in
                lastNameText.placeholder = self.lastNameLabel.text
            }
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { alertAction in
                let newInput = ac.textFields?.first?.text
                self.lastNameLabel.text = newInput
            }))
            present(ac, animated: true)
        } else if indexPath.section == CellPositions.Section.phone && indexPath.row == CellPositions.Row.phone {
            let ac = UIAlertController(title: "Edit Phone Number", message: "Please specify a new phone number.", preferredStyle: .alert)
            
            ac.addTextField{ (phoneText) -> Void in
                phoneText.placeholder = self.phoneLabel.text
                phoneText.keyboardType = .phonePad
            }
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            ac.addAction(UIAlertAction(title: "Verify", style: .destructive, handler: { alertAction in
                let newInput = ac.textFields?.first?.text
                self.phoneLabel.text = newInput
            }))
            present(ac, animated: true)
        }
    }

}

extension BasicInfoTableViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.avatarImageView.image = image
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}
