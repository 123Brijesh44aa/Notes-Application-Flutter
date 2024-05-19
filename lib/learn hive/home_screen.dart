import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hive Database",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // context :  batata hai ki aap kis part of the widget tree mein hain. Har widget ke andar context hota hai, aur yeh information provide karta hai about the widget's location, theme, media query, navigation, etc. Iske bina, hum kuch specific information ko access nahi kar sakte.

              // SnapShot : Jab aap kisi asynchronous operation ka result wait kar rahe hote hain, jaise ki network call ya file read, tab aapko ek Snapshot milta hai. Yeh batata hai ki aapki operation kis state(waiting,data,error) mein hai.

              FutureBuilder(
                  // Yaha pe hum apne Future object ko pass karte hain
                  future: Hive.openBox("Brijesh_Hive"),
                  builder: (context, snapshot) {
                    return Container(
                      color: Colors.deepPurpleAccent.shade100,
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(snapshot.data!.get("name").toString(),style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                            subtitle:
                                Text(snapshot.data!.get("age").toString(),style: const TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                            trailing: CircleAvatar(
                              child: IconButton(
                                onPressed: () {
                                  snapshot.data?.put(
                                      "name", "Hello There!!! This is brijesh");
                                  setState(() {});
                                },
                                icon: const Icon(
                                  Icons.tips_and_updates_rounded,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                            ),
                            leading: CircleAvatar(
                              child: IconButton(
                                onPressed: () {
                                  snapshot.data!.delete("name");
                                  setState(() { });
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.deepPurpleAccent,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Box are like files and they stores data in it.
          // openBox() is a function which creates a file to store data
          // we can create multiple boxes

          var box = await Hive.openBox("Brijesh_Hive");

          box.put("name", "Brijesh Mourya");

          box.put("age", 33);

          box.put("details", {
            "pro": "developer",
            "hello": "world",
          });

          print(box.get("name"));
          print(box.get("details")["pro"]);
        },
        child: const Icon(
          Icons.add_circle,
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }
}
