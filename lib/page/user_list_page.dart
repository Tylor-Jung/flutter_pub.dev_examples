import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_package/mdel/inputform.dart';
import 'dart:developer';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  Timer? _timer;
  late double _progress;

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  late Box _darkMode;
  late Box<InputForm> _InputFormBox;

  @override
  void initState() {
    super.initState();
    _darkMode = Hive.box('darkModeBox');
    _InputFormBox = Hive.box<InputForm>('InputFormBox');
    EasyLoading.addStatusCallback((status) {
      print('EasyLoading Status $status');
      if (status == EasyLoadingStatus.dismiss) {
        _timer?.cancel();
      }
    });
    EasyLoading.showSuccess('Use in initState');
    // EasyLoading.removeCallbacks();
  }

  bool isDarkMode = false;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          CupertinoSwitch(
            value: isDarkMode,
            onChanged: (val) {
              setState(() {
                isDarkMode = val;
                _darkMode.put('darkMode', val);
              });
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  label: Text('name'),
                ),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  label: Text('age'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: const Text('show'),
                    onPressed: () async {
                      _timer?.cancel();
                      await EasyLoading.show(
                        status: 'loading...',
                        maskType: EasyLoadingMaskType.black,
                      );
                      print('EasyLoading show');
                    },
                  ),
                  TextButton(
                    child: const Text('dismiss'),
                    onPressed: () async {
                      _timer?.cancel();
                      await EasyLoading.dismiss();
                      print('EasyLoading dismiss');
                    },
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _InputFormBox.add(
                    InputForm(
                      name: nameController.text,
                      age: int.parse(ageController.text),
                    ),
                  );
                },
                child: const Text('add'),
              ),
            ],
          ),
          const Divider(),
          ValueListenableBuilder(
            valueListenable: Hive.box<InputForm>('inputFormBox').listenable(),
            builder: (context, Box<InputForm> inputFormBox, widget) {
              final users = inputFormBox.values.toList();

              return Expanded(
                child: users.isEmpty
                    ? const Text('empty')
                    : ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, i) {
                          // IconButton(
                          //     icon: const Icon(Icons.delete),
                          //     onPressed: () {
                          //       final inputForm = users[i];
                          //     });

                          return ListTile(
                            title: Text(users[i].name),
                            subtitle: Text(users[i].age.toString()),
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
