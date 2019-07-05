/*
以下が修正箇所
 ・セルのreusable問題を解決
 ・checkmarkの付け外しをタップで（セル内のデータにその情報を格納するように）
 ・Dateが投稿取得時のものにならない
 ・Firebaseからデータを取得する時のやり方について研究
 ・Imageをボタンにする方法について
 ・popular部分の実装＋コードのリファクタリング
 */

import UIKit
import Firebase

enum PostCategory: String {
    case funny = "funny"
    case serious = "serious"
    case crazy = "crazy"
    case popular = "popular"
}

class ViewController1: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // UI部品の宣言
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl! // segmentedControlはOutletのUI部品として定義する必要がある！
    
    
    // 投稿を格納する配列
    var postArray = [Post]()
    
    // Firebaseの参照元を指定するための初期変数を宣言
    var postsCollectionRef: CollectionReference!
    var postsListner: ListenerRegistration!
    
    // カテゴリによるソーティング
    var selectedCategory = PostCategory.funny.rawValue
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableViewのデリゲートメソッドの有効化
        tableView.delegate = self
        tableView.dataSource = self
        
        // Firebaseの参照元を指定
        postsCollectionRef = Firestore.firestore().collection(POSTS)
        
    }
    
    // segmentedControlの値によってcategoryの値を切り替える
    @IBAction func categoryChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedCategory = PostCategory.funny.rawValue
        case 1:
            selectedCategory = PostCategory.serious.rawValue
        case 2:
            selectedCategory = PostCategory.crazy.rawValue
        default:
            selectedCategory = PostCategory.popular.rawValue
        }
        
        // 一回リスナーをリセットし、再びセットする。
        postsListner.remove()
        setListner()
        
    }
    
    
    // ☆☆☆viewWillAppear内でFirebaseからデータを取得☆☆☆ //
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setListner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        postsListner.remove()
    }
    
    // イベントリスナーを宣言
    func setListner() {
        
        if selectedCategory == PostCategory.popular.rawValue {
            postsListner = postsCollectionRef
                .order(by: NUM_LIKES, descending: true)
                .addSnapshotListener({ (snapshot, error) in
                    if let err = error {
                        debugPrint("エラー：\(err)")
                    } else {
                        // 配列を初期化
                        self.postArray = [Post]()
                        
                        // リファクタリングするとこうなる↓（クラスの方にメソッドとして宣言してしまう）
                        self.postArray = Post.parseData(snapshot: snapshot)
                        
                        self.tableView.reloadData()
                    }
                })
        } else {
            postsListner = postsCollectionRef
                .whereField(CATEGORY, isEqualTo: selectedCategory)
                .order(by: TIMESTAMP, descending: true)
                .addSnapshotListener({ (snapshot, error) in
                    if let err = error {
                        debugPrint("エラー：\(err)")
                    } else {
                        // 配列を初期化
                        self.postArray = [Post]()
                        
                        self.postArray = Post.parseData(snapshot: snapshot)
                        
                        self.tableView.reloadData()
                    }
                })
        }
    }
    
    
    // ☆☆☆以下、tableViewに関する設定☆☆☆ //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellController {
            cell.configureCell(posty: postArray[indexPath.row])
            return cell
        } else { return UITableViewCell() } // セルが存在しなかった場合
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップされたセルをdeselectedに戻す
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 128
        
    }
    
    
}

