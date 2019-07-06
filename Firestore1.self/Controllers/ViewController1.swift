

import UIKit
import Firebase

class ViewController1: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // @@@@@@@@@@ 変数の宣言、segmentedControlによる切り替え @@@@@@@@@@ //
    
    // UI部品の宣言
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl! // segmentedControlはOutletのUI部品として定義する必要がある！
    
    // 投稿を格納する配列
    var postArray = [Post]()
    
    // カテゴリによるソーティング
    var selectedCategory = PostCategory.funny.rawValue
    
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
        removeListner()
        setListner()
    }
    
    // Firebaseの参照元を指定するための初期変数を宣言
    var postsCollectionRef: CollectionReference!
    var postsListner: ListenerRegistration!
    
    // タップされたセルのデータ
    var currentTitle = String()
    var currentContent = String()
    var tappedId = String()
    
    
    // @@@@@@@@@@ viewWill系 @@@@@@@@@@ //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // tableViewのデリゲートメソッドの有効化
        tableView.delegate = self
        tableView.dataSource = self
        // Firebaseの参照元を指定
        postsCollectionRef = Firestore.firestore().collection(POSTS)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setListner()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        removeListner()
    }
    
    
    
    // @@@@@@@@@@ イベントリスナー系 @@@@@@@@@@ //
    
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
                        // リファクタリング。配列の初期化もメソッド内に含めた。
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
                        // リファクタリング。配列の初期化もメソッド内に含めた。
                        self.postArray = Post.parseData(snapshot: snapshot)
                        
                        self.tableView.reloadData()
                    }
                })
        }
    }
    
    // リスナーをリセットするメソッド
    func removeListner() {
        postsListner.remove()
    }
    
    
    
    // @@@@@@@@@@ 以下、tableViewに関する設定 @@@@@@@@@@ //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellController {
            cell.configureCell(posty: postArray[indexPath.row])
            // 「checkmark」のBool値に応じてセルのアクセサリータイプを「.checkmark」に
            cell.accessoryType = postArray[indexPath.row].checkmark ? .checkmark : .none
            return cell
        } else { return UITableViewCell() } // セルが存在しなかった場合
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // タップされたセルをdeselectedに戻す
        tableView.deselectRow(at: indexPath, animated: true)
        
        // タップされたセルのtitleとcontentデータを取得してvc2に渡しながら遷移
        currentTitle = postArray[indexPath.row].title
        currentContent = postArray[indexPath.row].content
        tappedId = postArray[indexPath.row].documentId
        
        // 遷移先のVCを宣言＋値を送信＋画面を遷移
        let vc2: ViewController2 = self.storyboard?.instantiateViewController(withIdentifier: "vc2") as! ViewController2
        vc2.titlePlaceholder = currentTitle
        vc2.contentPlaceholder = currentContent
        vc2.tappedId = tappedId
        self.navigationController?.pushViewController(vc2, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // 消去だった場合
        if editingStyle == .delete {
            // Firestoreから該当箇所を削除
            postsCollectionRef.document(postArray[indexPath.row].documentId).delete()
            // TVのリロード
            tableView.reloadData()
        }
    }
    

}

