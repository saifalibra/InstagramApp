//
//  ComentViewController.swift
//  Instagram
//
//  Created by 高橋怜杏 on 2020/04/03.
//  Copyright © 2020 saifa.libra. All rights reserved.
//

import UIKit
import Firebase

class ComentViewController: UIViewController {
    
    var postid = ""
    @IBOutlet weak var comenttextfield: UITextField!
    @IBAction func comentsendButton(_ sender: Any) {
        
        let comentref = Firestore.firestore().collection(Const.Postpath).document(postid)
        let name = Auth.auth().currentUser?.displayName
        let coments = "\(name!) : \(comenttextfield.text!)"
        var updateValue: FieldValue
        updateValue = FieldValue.arrayUnion([coments])
        comentref.updateData(["comment": updateValue])
        self.dismiss(animated: true, completion: nil)
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
