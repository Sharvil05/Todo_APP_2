import 'package:flutter/material.dart';
import 'package:sqf_lite_2/bottomsheet_view.dart';
import 'package:sqf_lite_2/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController taskcontroller = TextEditingController();

  List<Map<String, dynamic>> allTasks = [];
  DbHelper? dbreference;

  @override
  void initState() {
    super.initState();
    dbreference = DbHelper.getinstance;
    getTask();
  }

  void getTask() async {
    allTasks = await dbreference!.getallTask();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: Text(
          "To-Do App",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 171, 98, 98),
      ),

      body: allTasks.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: allTasks.length,
              itemBuilder: (context, index) {

                return InkWell(
                  onTap: () {
                    //OPEN FOR UPDATE
                    taskcontroller.text = allTasks[index]["task"];

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) {
                        return BottomSheetView(
                          taskcontroller: taskcontroller,
                          dbreference: dbreference!,
                          getTask: getTask,
                          isUpdate: true,
                          id: allTasks[index]["id"],
                        );
                      },
                    );
                  },

                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),

                    child: Row(
                      children: [

                        /// CHECKBOX 
                        Checkbox(
                          value: allTasks[index]["is_done"] == 1,
                          onChanged: (value)async {

                            int id = allTasks[index]["id"];

                            await dbreference!.updateTaskStatus(id: id, isdone: value! ? 1:0);
                            getTask();
                            

                            

                          },
                          activeColor: Colors.black,
                        ),

                        /// TASK TEXT
                        Expanded(
                          child: Text(
                            allTasks[index]["task"],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              decoration:
                                  allTasks[index]["is_done"] == 1
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                            ),
                          ),
                        ),

                        /// DELETE
                        IconButton(
                          onPressed: () async {

                            bool? confirm = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Delete Task"),
                                  content: Text("Are you sure you want to delete this task?"),
                                  actions: [

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, false); // cancel
                                      },
                                      child: Text("Cancel"),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, true); // confirm
                                      },
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                        if (confirm == true) {

                          int id = allTasks[index]["id"];

                          bool check = await dbreference!.deleteTask(id: id);

                          if (check) {
                            getTask(); // refresh UI
                          }
                        }
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "No Tasks Yet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Tap + to add a task",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

      /// ADD TASK (FAB)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) {
              return BottomSheetView(
                taskcontroller: taskcontroller,
                dbreference: dbreference!,
                getTask: getTask,
                isUpdate: false, //  ADD MODE
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}