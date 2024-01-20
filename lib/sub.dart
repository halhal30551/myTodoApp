//入力、出力、削除関数とクラス
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

final taskProvider = StateProvider((ref) => '');  //task入力管理
final noteProvider = StateProvider((ref) => '');  //note入力管理
final taskModelProvider = StateProvider((ref) => []); //taskModel配列管理

Future<void> jsonWriter(WidgetRef ref, String key)async {     //task追加関数
  var task = ref.read(taskProvider.notifier).state;
  var note = ref.read(noteProvider.notifier).state;
  ref.read(taskProvider.notifier).state = '';
  ref.read(noteProvider.notifier).state = '';   //入力を抽出、Providerリセット
  if(task==''){   //taskフィールドは必須、空なら追加なし
    return;
  }
  if(note==''){   //noteフィールドは任意、空なら自動補填
    note='no note';
  }
  var add_taskmodel=TaskModel(task: task, note: note);    //インスタンス化
  var add_josn=add_taskmodel.toJson();    //Map形式
  var add_string=jsonEncode(add_josn);    //Stringリスト
  SharedPreferences prefs  = await SharedPreferences.getInstance(); //データアクセス
  var d = prefs.getStringList(key);   //データ読み出し
  List<String> data=[];
  if (d!=null){   //読み出しデータが空でないとき
    data = d;
  }
  data.add(add_string);   //Stringリストに追加
  await prefs.setStringList(key, data);   //データ上書き
  List<TaskModel> taskList=[];
  for(int i=0;i<data.length;i++){   //TaskModelのインスタンスリストにする
    var a_json = jsonDecode(data[i]);
    var a_taskModel = TaskModel.fromJson(a_json);
    taskList.add(a_taskModel);
  }
  ref.read(taskModelProvider.notifier).state = taskList;    //providerに
  return;
}

Future<void> jsonReader(String key, WidgetRef ref) async {  //データ読み出し関数
  List<TaskModel> list=[];
  SharedPreferences prefs  = await SharedPreferences.getInstance(); //データアクセス
  var data = prefs.getStringList(key);    //データ読み出し
  if (data==null){    //データ空なら、Providerに空リスト反映
    ref.read(taskModelProvider.notifier).state = list;
    return;
  }
  for(int i=0;i<data.length;i++){   //taskModelインスタンスリスト化
    var a_json=jsonDecode(data[i]);
    var a_Taskmodel=TaskModel.fromJson(a_json);
    list.add(a_Taskmodel);
  }
  ref.read(taskModelProvider.notifier).state = list;  //ProviderにtaskModelインスタンスリスト反映
  return;
}

Future<void> jsonDelete(List<dynamic>? task,int index, String key, WidgetRef ref)async {//task削除関数
  if(task==null){//task空、多分起こらない
    print('task is NULL at jsonDelete');
    return;
  }
  List<TaskModel> list = [];
  SharedPreferences prefs  = await SharedPreferences.getInstance();//データアクセス
  var data = prefs.getStringList(key);//データ読み出し
  if (data==null){//データ空、多分起こらない
    print('data is NULL at jsonDelete');
    return;
  }
  for(int i=0;i<data.length;i++){   //taskModelインスタンスリスト化
    var a_json=jsonDecode(data[i]);
    var a_Taskmodel=TaskModel.fromJson(a_json);
    list.add(a_Taskmodel);
  }
  for(int i=0;i<list.length;i++){//task,note両方一致が削除（全く同じタスクが複数あったら全部消える）
    if((list[i].task==task[index].task)&&(list[i].note==task[index].note)) {
      list.removeAt(i);
    }
  }
  List<String> setData=[];
  for(int i=0;i<list.length;i++){//Stringリストにする
    Map<dynamic, dynamic> a_json=list[i].toJson();
    var a_string=jsonEncode(a_json);
    setData.add(a_string);
  }
  await prefs.setStringList(key, setData);    //データ上書き
  ref.read(taskModelProvider.notifier).state = list;  //ProviderにtaskModelインスタンスリスト反映
  return;
}

Future<void> AllDelete(String key, WidgetRef ref)async {//task削除関数（全部）
  List<TaskModel> list = [];
  SharedPreferences prefs  = await SharedPreferences.getInstance();//データアクセス
  List<String> setData=[];
  await prefs.setStringList(key, setData);    //データ上書き
  ref.read(taskModelProvider.notifier).state = list;  //ProviderにtaskModelインスタンスリスト反映
  return;
}

class TaskModel{    //TaskModelクラス
  String task;
  String note;
  TaskModel({
    required this.task, required this.note,
  });

  Map toJson() =>{
    'task':task, 'note':note,
  };

  TaskModel.fromJson(Map json):
    task=json['task'],
    note=json['note'];
}
