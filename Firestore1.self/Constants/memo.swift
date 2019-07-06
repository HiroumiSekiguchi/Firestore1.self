//
//  memo.swift
//  Firestore1.self
//
//  Created by 関口大海 on 2019/07/05.
//  Copyright © 2019 関口大海. All rights reserved.
//

import Foundation

/*
 
 以下が未解決の箇所
 // funny, serious, crazyのクリック問題
 // setListner()内コードのリファクタリングがバグってたので元に戻した（原因特定して正常に機能させたい...）
 // セルのreusable問題を解決（データに直接プロパティを保持する）
 // checkmarkの付け外しをタップで（セル内のデータにその情報を格納、上書きするように）
 // セルの内容の編集機能（それ用のページに行って編集、上書き）
 ・Firebaseからデータを取得する時のやり方について研究（ピンポイントで対応するデータだけを取得するには？これが今はできない。）
 // Firebaseにデータを上書きする方法も（モデル内にしっかりdocumentIdの指定を入れる！）
 ・Dateが投稿取得時のものにならない
 ・投稿やアップデートのDateによるソートの実装（3segmentにおいて。）＊reloadDataの機能障害のため一回外してしまったので。
 ・Imageをボタンにする方法について（まぁ自力で実装はできなくてもいいのでは）
 // セルの削除機能（できた。ただ、funny,serious,crazyでTVがreloadData()されない...なぜだ...）
 // 投稿のtimestampでソートする部分はできた（インデックスの作成？が出来ていなかった）
 ＜残りのマスト事項＞
 # Firebaseからデータをピンポイントで取得する方法（＋Firestoreに関する研究）
 # Date型を変換してtimestampLabelに表示する
 
 ＜余力があれば＞
 # Imageをボタンにする方法について
 # セルの高さを動的に変える
 
 */



