//
//  CellController.swift
//  Firestore1.self
//
//  Created by 関口大海 on 2019/07/05.
//  Copyright © 2019 関口大海. All rights reserved.
//

import UIKit
import Firebase

class CellController: UITableViewCell {
    
    // UI部品の宣言
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var numLikesLabel: UILabel!
    
    // インスタンスのレファレンスを設定
    var postRef: Post!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // セルを構築するメソッドを宣言
    func configureCell(posty: Post) {
        self.postRef = posty
        
        titleLabel.text = posty.title
        contentLabel.text = posty.content
        numLikesLabel.text = String(posty.numLikes)
        
        // Date型からString型の日付を生成⑴
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
//        dateFormatter.dateFormat = "MM/dd HH:mm"
//        let timestampy = dateFormatter.string(from: posty.timestamp)
//        timestampLabel.text = timestampy
        
    }
    
    // ハートボタンをタップした時の処理
    @IBAction func likeButtonTapped(_ sender: Any) {
        
        Firestore.firestore().collection(POSTS).document(postRef.documentId)
            .updateData([NUM_LIKES: postRef.numLikes + 1])
        
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        
        Firestore.firestore().collection(POSTS).document(postRef.documentId)
            .updateData([CHECKMARK: !postRef.checkmark])
        
    }
    
    
    
    
}
