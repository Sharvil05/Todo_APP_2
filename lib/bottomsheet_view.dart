import 'package:flutter/material.dart';
import 'package:sqf_lite_2/database_helper.dart';
import 'package:sqf_lite_2/home_page.dart';

// ignore: must_be_immutable
class BottomSheetView extends StatefulWidget {

  final TextEditingController taskcontroller;
  DbHelper dbreference;
  Function getTask;   
  
  bool isUpdate;
  int? id;                           // DOUT HERE
  // ignore: prefer_const_constructors_in_immutables

  BottomSheetView({
    super.key,
    required this.taskcontroller,
    required this.dbreference, 
    required this.getTask,
    this.isUpdate = false,
    this.id
  });

  @override
  State<BottomSheetView> createState() => _BottomSheetViewState();
}

class _BottomSheetViewState extends State<BottomSheetView> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// TITLE
          Text(
            "Add Task",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20),

          /// TEXT FIELD
          TextField(
            controller: widget.taskcontroller,
            decoration: InputDecoration(
              hintText: "Enter your task",
              filled: true,
              fillColor: Colors.grey.shade100,
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          SizedBox(height: 20),

          /// BUTTONS
          Row(
            children: [

              /// ADD BUTTON
              Expanded(
                child: ElevatedButton(
                  onPressed: ()async{
                    // Add your insert logic here

                    var task = widget.taskcontroller.text.trim();
                    if(task.isNotEmpty){

                      bool check = widget.isUpdate 
                      ? await widget.dbreference.updateTask(id: 
                      widget.id!, task: task): await widget.dbreference.addTask(task: task);

                      if(check){

                        widget.getTask();                          // DOUT HERE
                        widget.taskcontroller.clear();
                        Navigator.pop(context);

                      }
                    }else{

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter task"))
                        );
                      }
                      setState(() {
                        
                      });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(widget.isUpdate ? "UPDATE" : "ADD Task"),
                ),
              ),

              SizedBox(width: 10),

              /// CANCEL BUTTON
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text("Cancel"),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}