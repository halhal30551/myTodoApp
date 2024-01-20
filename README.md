# myTodoApp

ローカルで動く一般的なTODOアプリ

## 使い方(How To Use)

+アイコンのボタン又はメニューから「Add Task」を選択する  
 - 「TASK」...やるべきことのタイトル（必須）  
 - 「NOTE」...詳細など（無記入でも可）  
 - 「ADD TASK」ボタン押すと追加される  

各タスクを押すと、詳細（NOTE）が表示される  
タスクが完了したときは、「complete this task」ボタンを押すとタスクが削除される  

メニューの「Random Task」を押すと、現在作成されているタスクからランダムに１つ選ばれる  
選ばれたタスクは完了させ、「complete this task」ボタンを押して削除しなければならない  

メニューの「Delete All Tasks」を押すと、現在作成されているタスク全てが削除される

## 設計方針(Design Policy)

画面（Widget）と関数をなるべく分ける  
 - main.dart...画面  
 - sub.dart...関数  

授業で扱われた要素をなるべく使う（riverpod, listView, bottomSheet, Navigator, 非同期処理）  

作成されたタスクを端末に保存できるようにする

## 工夫したポイント(Device Point)

メイン画面とタスク追加画面の画面遷移を「push」「pop」ではなく「pushReplacement」を使うことで、戻るボタンを排除した  
これによって戻るボタンを使われたときに、入力（文字列）が保持されてしまう挙動を回避した  

作成されたタスクを端末の補助記憶装置に保存し、アプリケーションを再起動しても、タスクが失われないように、「shared_preferences」を利用した

## 動作環境(Operating Environment)

Flutter : 3.13.9  
dart(SDK) : >=3.1.5 <4.0.0  

cupertino_icons : ^1.0.2  
flutter_riverpod : ^2.4.9  
riverpod_annotation : ^2.3.3  
shared_preferences : ^2.2.2  

flutter_lints : ^2.0.0  
riverpod_generator : ^2.3.9  
build_runner : ^2.4.7  
custom_lint : ^0.5.7  
riverpod_lint : ^2.3.7
