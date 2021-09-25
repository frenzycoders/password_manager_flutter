// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/src/Controllers/settings_controller.dart';

class PinCreate extends StatefulWidget {
  @override
  State<PinCreate> createState() => _PinCreateState();
}

class _PinCreateState extends State<PinCreate> {
  TextEditingController firstpinController = TextEditingController();
  TextEditingController secondPinController = TextEditingController();
  TextEditingController thirdPinController = TextEditingController();
  TextEditingController fourthPinController = TextEditingController();
  late FocusNode first;
  late FocusNode second;
  late FocusNode third;
  late FocusNode fourth;
  late SettingsController appController;
  int count = 0;
  executeCode(value) {
    if (count > 3) {
      count = 0;
      firstpinController.text = '';
      secondPinController.text = '';
      thirdPinController.text = '';
      fourthPinController.text = '';
      setState(() {});
    } else {
      if (count == 0) {
        firstpinController.text = value.toString();
        second.requestFocus();
      }
      if (count == 1) {
        secondPinController.text = value.toString();
        third.requestFocus();
      }
      if (count == 2) {
        thirdPinController.text = value.toString();
        fourth.requestFocus();
      }
      if (count == 3) {
        fourthPinController.text = value.toString();
        first.requestFocus();
      }
      setState(() {
        count++;
      });
    }
  }

  removeNumber() {
    if (count <= 4) {
      if (count == 1) {
        first.requestFocus();
        firstpinController.text = '';
        count--;
      }
      if (count == 2) {
        second.requestFocus();
        secondPinController.text = '';
        count--;
      }
      if (count == 3) {
        third.requestFocus();
        thirdPinController.text = '';
        count--;
      }
      if (count == 4) {
        fourth.requestFocus();
        fourthPinController.text = '';
        count--;
      }
    }
    setState(() {});
  }

  savePinandActivatePinLogin() {
    appController.savePinAndEnableIt(firstpinController.text +
        secondPinController.text +
        thirdPinController.text +
        fourthPinController.text);
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appController = Get.find<SettingsController>();
    first = FocusNode();
    second = FocusNode();
    third = FocusNode();
    fourth = FocusNode();
    first.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: 20),
            ),
            SliverAppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Obx(() {
                  return appController.theme.value == 'light'
                      ? const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.blueGrey,
                        )
                      : const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                        );
                }),
              ),
              title: const Text('Create Password'),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            height: 60,
                            width: 50,
                            child: TextField(
                              focusNode: first,
                              controller: firstpinController,
                              showCursor: true,
                              readOnly: true,
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            height: 60,
                            width: 50,
                            child: TextField(
                              focusNode: second,
                              controller: secondPinController,
                              showCursor: true,
                              readOnly: true,
                              onChanged: (value) {},
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            height: 60,
                            width: 50,
                            child: TextField(
                              focusNode: third,
                              controller: thirdPinController,
                              showCursor: true,
                              readOnly: true,
                              onChanged: (value) {},
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            height: 60,
                            width: 50,
                            child: TextField(
                              focusNode: fourth,
                              controller: fourthPinController,
                              showCursor: true,
                              readOnly: true,
                              onChanged: (value) {},
                              decoration: const InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blueAccent, width: 2.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  executeCode(1);
                                },
                                child: Card(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      '1',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  executeCode(2);
                                },
                                child: Card(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      '2',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  executeCode(3);
                                },
                                child: Card(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      '3',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  executeCode(4);
                                },
                                child: Card(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      '4',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  executeCode(5);
                                },
                                child: Card(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      '5',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  executeCode(6);
                                },
                                child: Card(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      '6',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  executeCode(7);
                                },
                                child: Card(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      '7',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  executeCode(8);
                                },
                                child: Card(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      '8',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  executeCode(9);
                                },
                                child: Card(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      '9',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: 60,
                                width: 60,
                                padding: const EdgeInsets.all(10),
                                child: const Text(
                                  '',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  executeCode(0);
                                },
                                child: Card(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(10),
                                    child: const Text(
                                      '0',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  removeNumber();
                                },
                                child: Card(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: 60,
                                    padding: const EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.clear,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    count == 4
                        ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(10),
                            child: RaisedButton(
                              elevation: 5,
                              onPressed: () {
                                savePinandActivatePinLogin();
                              },
                              child: Text('SAVE'),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
