//
//  HomeViewController.swift
//  Instagram
//
//  Created by 高橋怜杏 on 2020/03/23.
//  Copyright © 2020 saifa.libra. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []

    var listener: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        
        if Auth.auth().currentUser != nil {
            if listener == nil {
                
                let postRef = Firestore.firestore().collection(Const.Postpath).order(by: "date", descending: true)
                
                listener = postRef.addSnapshotListener(){ (querySnapshot, error) in
                    if let error = error {
                        print("DEBUG_PRINT: snapshotの取得が失敗しました。\(error)")
                        return
                }
                                  
                    self.postArray = querySnapshot!.documents.map {
                        document in
                        print("DEBUG_PRINT: document取得 \(document.documentID)")
                        let postData = PostData(document: document)
                        print(postData);
                        return postData
                    }
                    
                    self.tableView.reloadData()
            }
        }
        } else {
            if listener != nil {
                listener.remove()
                listener = nil
                postArray = []
                tableView.reloadData()
            }
        }
    }
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return postArray.count
      }
      
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
          cell.setPostData(postArray[indexPath.row])
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        cell.comentButton.addTarget(self, action: #selector(handlecomentButton(_:forEvent:)), for: .touchUpInside)
        
          return cell
      }
    
    @objc func handlecomentButton(_ sender: UIButton, forEvent event: UIEvent){
         print("DEBUG_PRINT: comentボタンがタップされました。")
        let storyboard: UIStoryboard = self.storyboard!
        let comentViewController = storyboard.instantiateViewController(withIdentifier: "Coment") as! ComentViewController
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        comentViewController.postid = postData.id
        
        self.present(comentViewController, animated: true)
        
    }
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        let postData = postArray[indexPath!.row]
        
        if let myid = Auth.auth().currentUser?.uid {
            
            var updateValue: FieldValue
            if postData.isLiked {
                
                updateValue = FieldValue.arrayRemove([myid])
            } else {
                updateValue = FieldValue.arrayUnion([myid])
            }
            
            let postRef = Firestore.firestore().collection(Const.Postpath).document(postData.id)
            postRef.updateData(["likes": updateValue])
        }
    }
}

