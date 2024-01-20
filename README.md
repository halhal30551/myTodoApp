# myTodoApp

ローカルで動く一般的なTODOアプリ

## 使い方(How To Use)

+アイコンのボタン又はメニューから「Add Task」を選択する\n
「TASK」...やるべきことのタイトル（必須）\n
「NOTE」...詳細など（無記入でも可）\n
「ADD TASK」ボタン押すと追加される\n

各タスクを押すと、詳細（NOTE）が表示される\n
タスクが完了したときは、「complete this task」ボタンを押すとタスクが削除される\n

メニューの「Random Task」を押すと、現在作成されているタスクからランダムに１つ選ばれる\n
選ばれたタスクは完了させ、「complete this task」ボタンを押して削除しなければならない\n

メニューの「Delete All Tasks」を押すと、現在作成されているタスク全てが削除される\n

## 設計方針(Design Policy)

画面（Widget）と関数をなるべく分ける\n
　- main.dart...画面\n
　- sub.dart...関数\n

授業で扱われた要素をなるべく使う（riverpod, listView, bottomSheet, Navigator, 非同期処理）\n

作成されたタスクを端末に保存できるようにする\n

## 工夫したポイント(Device Point)

メイン画面とタスク追加画面の画面遷移を「push」「pop」ではなく「pushReplacement」を使うことで、戻るボタンを排除した\n
これによって戻るボタンを使われたときに、入力（文字列）が保持されてしまう挙動を回避した\n

作成されたタスクを端末の補助記憶装置に保存し、アプリケーションを再起動しても、タスクが失われないように、「shared_preferences」を利用した\n

## 動作環境(Operating Environment)

Flutter : 3.13.9\n
dart(SDK) : >=3.1.5 <4.0.0\n

cupertino_icons : ^1.0.2\n
flutter_riverpod : ^2.4.9\n
riverpod_annotation : ^2.3.3\n
shared_preferences : ^2.2.2\n

flutter_lints : ^2.0.0\n
riverpod_generator : ^2.3.9\n
build_runner : ^2.4.7\n
custom_lint : ^0.5.7\n
riverpod_lint : ^2.3.7\n
