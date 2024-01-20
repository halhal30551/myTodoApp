//メイン関数とウィジェット
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/sub.dart';

void main() {
  runApp(
      const ProviderScope(child: MyApp())//const MyApp()
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'My Todo APP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'MY TODO APP'),
    );
  }
}

class MyHomePage extends ConsumerWidget {   //メイン画面
  MyHomePage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String Instancekey = "123456789";   //データアクセスkey
    jsonReader(Instancekey, ref);     //保存済みデータ読み出し
    var tasks = ref.watch(taskModelProvider);   //TaskModel配列監視
    if(tasks.isEmpty){    //taskがない時の画面
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(title),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                color: Colors.yellow,
                ),
                padding: const EdgeInsets.all(10),
                child: Container(
                  alignment: Alignment.center,
                  child: const Text('SIDE MENU', style: TextStyle(fontSize: 32),),
                ),
              ),
              const SizedBox(height: 32,),
              ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                    return TodoAdd(ref: ref, Instancekey: Instancekey);
                  }));
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.green,
                    width: 1,
                  ),
                ),
                child: const Text('Add Task', style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(height: 128,),
              Text('ADD', style: Theme.of(context).textTheme.displayMedium,),
              Text('YOUR TASK', style: Theme.of(context).textTheme.displayMedium,),
              Text('TO DO', style: Theme.of(context).textTheme.displayMedium,),
              const SizedBox(height: 64,),
              Text('Click +button', style: Theme.of(context).textTheme.displayMedium,),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(   //押したらtask追加画面に置き換え
          onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
              return TodoAdd(ref:ref, Instancekey: Instancekey,);
            }));
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
    }
    else{    //taskあるとき
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,
          title: Text(title),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                  decoration: const BoxDecoration(
                  color: Colors.yellow,
                ),
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text('SIDE MENU', style: TextStyle(fontSize: 32),),
                  ),
              ),
              const SizedBox(height: 32,),
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return TodoAdd(ref: ref, Instancekey: Instancekey);
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.green,
                      width: 1,
                    ),
                  ),
                  child: const Text('Add Task', style: TextStyle(fontSize: 20),)
              ),
              const SizedBox(height: 32,),
              ElevatedButton(
                  onPressed: (){
                    int rand=Random().nextInt(tasks.length);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return randomTask(ref: ref,Instancekey: Instancekey,tasks: tasks,index: rand,);
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.green,
                      width: 1,
                    ),
                  ),
                  child: const Text('Random Task', style: TextStyle(fontSize: 20),)
              ),

              const SizedBox(height: 32,),
              ElevatedButton(
                onPressed: (){
                  AllDelete(Instancekey, ref);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                    return MyHomePage(title: 'MY TODO APP');
                  }));
                },
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.green,
                    width: 1,
                  ),
                ),
                child: const Text('Delete All Tasks',style: TextStyle(fontSize: 20),),
              ),
            ],
          ),
        ),
        body: ListView.builder(     //taskをList表示
          itemBuilder: (context, index){
            return Card(
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 32),
                  child: Text(tasks[index].task,style: Theme.of(context).textTheme.headlineMedium,),
                ),
                onTap: (){showBottomSheet(context: context, builder: (context){   //備考、完了、シャッフルはBottomSheetに
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      color: Colors.amber,
                      alignment: Alignment.center,
                      child: Container(
                        height: 280,
                        width: MediaQuery.of(context).size.width-20,
                        color: const Color.fromRGBO(255, 255, 255, 0.9),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const SizedBox(height: 16,),
                            Text(tasks[index].note,style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.black,),
                            ),
                            const SizedBox(height: 32,),
                            ElevatedButton(   //押したらtask削除、HomePageに画面置き換え
                                onPressed: (){
                                  jsonDelete(tasks,index, Instancekey,ref);//index
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                                    return MyHomePage(title: 'MY TODO APP');
                                  }));
                                },
                                child: const Text('complete this task',style: TextStyle(fontSize: 20),)
                            ),
                            const SizedBox(height: 16,),
                            IconButton(
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.arrow_downward_outlined),
                                style: IconButton.styleFrom(
                                  side: const BorderSide(
                                    color: Colors.blue,
                                    width: 2,
                                  ),
                                  backgroundColor: Colors.white,
                                ),
                            )
                          ],
                        ),
                      )
                  );
                });},
              ),
            );},
          itemCount: tasks.length,
        ),

        floatingActionButton: FloatingActionButton(     //押したらtask追加画面に置き換え
          onPressed: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
              return TodoAdd(ref:ref, Instancekey: Instancekey,);
            }));
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
    }
  }
}

class TodoAdd extends ConsumerWidget{     //task追加画面
  const TodoAdd({super.key, required this.ref, required this.Instancekey});
  final WidgetRef ref;
  final String Instancekey;   //データアクセスkey

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('TODO ADD PAGE',),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('TASK', style: TextStyle(fontSize: 16)),
              TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(40),
                ],
                onChanged: (String input){    //入力をProviderに反映
                  ref.read(taskProvider.notifier).state=input;
                },
              ),
              const SizedBox(height: 32,),
              const Text('NOTE', style: TextStyle(fontSize: 16)),
              TextField(
                inputFormatters: [
                  LengthLimitingTextInputFormatter(65),
                ],
                onChanged: (String input){    //入力をProviderに反映
                  ref.read(noteProvider.notifier).state=input;
                },
              ),
              const SizedBox(height: 32,),
              ElevatedButton(    //押したらtask追加実行、HomePageに画面置き換え
                onPressed: (){
                  jsonWriter(ref, Instancekey);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                    return MyHomePage(title: 'MY TODO APP');
                  }));
                },
                child: const Text('ADD TASK',style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 32,),
              TextButton(
                onPressed: (){      //押したらProviderリセット、HomePageに画面置き換え
                  ref.read(taskProvider.notifier).state = '';
                  ref.read(noteProvider.notifier).state = '';
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                    return MyHomePage(title: 'MY TODO APP');
                  }));
                },
                child: const Text('click to back (cancel)',style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class randomTask extends ConsumerWidget{    //ランダムにタスクを選んだページ
  const randomTask({super.key, required this.ref, required this.Instancekey, required this.tasks, required this.index});
  final WidgetRef ref;
  final String Instancekey; //データアクセスkey
  final List<dynamic> tasks;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('RANDOM TASK PAGE'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('DO IT!!', style: Theme.of(context).textTheme.displaySmall,),
              const SizedBox(height: 32,),
              Text('JUST NOW!!',style: Theme.of(context).textTheme.displaySmall,),
              const SizedBox(height: 32,),
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                color: Colors.red[900],
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 0),
                  alignment: Alignment.center,
                  color: const Color.fromRGBO(255, 255, 255, 0.95),
                  child: Column(
                    children: [
                      Text('task', style: Theme.of(context).textTheme.headlineMedium,),
                      Text(tasks[index].task,style: Theme.of(context).textTheme.displayMedium),
                      const SizedBox(height: 32,),
                      Text('note', style: Theme.of(context).textTheme.headlineMedium,),
                      Text(tasks[index].note,style: Theme.of(context).textTheme.displaySmall),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 64,),
              ElevatedButton(     //押したらタスク削除、HomePageに画面置き換え
                  onPressed: (){
                    jsonDelete(tasks, index, Instancekey, ref);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
                      return MyHomePage(title: 'MY TODO APP');
                    }));
                  },
                  child: const Text('complete this task', style: TextStyle(fontSize: 24),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
