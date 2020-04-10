//
//  SettingViewController.swift
//  Instagram
//
//  Created by 高橋怜杏 on 2020/03/23.
//  Copyright © 2020 saifa.libra. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text {
            
        if displayName.isEmpty {
                      SVProgressHUD.showError(withStatus: "表示名を入力して下さい")
                      return
                  }
            
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequeust = user.createProfileChangeRequest()
                changeRequeust.displayName = displayName
                changeRequeust.commitChanges { error in
                    if let error = error{
                        SVProgressHUD.showError(withStatus: "表示名の変更に失敗しました。")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                        print("DEBUG_PRINT:  [displayName = \(user.displayName!)]の設定に成功しました。")
                    
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                    }
                }
            }
        
            self.view.endEditing(true)
        }

    
    
    @IBAction func handleLogoutButton(_ sender: Any) {
        
        try! Auth.auth().signOut()
        
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
