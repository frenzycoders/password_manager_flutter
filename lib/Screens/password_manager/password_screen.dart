// ignore_for_file: prefer_is_empty, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/Screens/search_screen.dart';
import 'package:password_manager/Screens/settings/Settings.dart';
import 'package:clipboard/clipboard.dart';
import 'package:password_manager/src/Controllers/cloud_controller.dart';
import 'package:password_manager/src/Controllers/password_controller.dart';
import 'package:password_manager/src/Controllers/settings_controller.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:password_manager/src/HttpException.dart';
import 'package:password_manager/src/models/password_storage.dart';

class PasswordScreen extends StatefulWidget {
  Function openDrawer;
  AnimationController drawerAnimation;
  Function setPosition;
  PasswordScreen({
    Key? key,
    required this.openDrawer,
    required this.drawerAnimation,
    required this.setPosition,
  }) : super(key: key);

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen>
    with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool showOptions = false;
  late AnimationController _controller;
  late Animation<Offset> _position;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showOptions = false;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _position = Tween<Offset>(begin: Offset(0.0, 2.0), end: Offset(0.0, 0.0))
        .animate(_controller);
  }

  changeValue() {
    setState(() {
      if (showOptions) {
        _controller.reverse();
        showOptions = false;
      } else {
        _controller.forward();
        showOptions = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    PasswordController appController = Get.find<PasswordController>();
    SettingsController settingsController = Get.find<SettingsController>();
    CloudController cloudController = Get.find<CloudController>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(height: 20),
          ),
          SliverAppBar(
            leading: Container(),
            leadingWidth: 0,
            toolbarHeight: 60,
            title: const Text('Password Manager'),
            expandedHeight: 50,
            //stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              // ignore: unrelated_type_equality_checks
              title: Obx(() {
                return Text(
                  'Keep your passwords with you.',
                  style: TextStyle(
                      fontSize: 10,
                      // ignore: unrelated_type_equality_checks
                      color: settingsController.theme == 'light'
                          ? Colors.blueGrey
                          : Colors.white70),
                );
              }),
              titlePadding: const EdgeInsets.only(left: 20),
            ),
          ),
          Obx(
            () {
              return SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: settingsController.isLoading.isTrue
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : appController.passwords.value.length > 0
                        ? SliverFixedExtentList(
                            itemExtent: 85.0,
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => Card(
                                elevation: 3,
                                color: settingsController.theme == 'light'
                                    ? const Color(0xff416d6d)
                                    : Colors.blueGrey,
                                child: ListTile(
                                    //leading: const Icon(Icons.person),
                                    onTap: () async {
                                      try {
                                        await cloudController
                                            .copyPasswordToClipBoard(
                                          message: () {
                                            ScaffoldMessenger.maybeOf(context)!
                                                .showSnackBar(
                                              settingsController.customSnachBar(
                                                  'Password copied.'),
                                            );
                                          },
                                          passwordStorage: appController
                                              .passwords.value[index],
                                        );
                                      } on HttpException catch (e) {
                                        ScaffoldMessenger.maybeOf(context)!
                                            .showSnackBar(
                                          settingsController
                                              .customSnachBar(e.message),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.maybeOf(context)!
                                            .showSnackBar(
                                          settingsController
                                              .customSnachBar(e.toString()),
                                        );
                                      }
                                    },
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          appController
                                              .passwords.value[index].title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Obx(() {
                                              return settingsController
                                                      .uploadCloud.isTrue
                                                  ? appController
                                                              .passwords
                                                              .value[index]
                                                              .uploaded ==
                                                          true
                                                      ? SizedBox(height: 0)
                                                      : IconButton(
                                                          onPressed: () async {
                                                            try {
                                                              if (await InternetConnectionChecker()
                                                                  .hasConnection) {
                                                                final password =
                                                                    await cloudController.createPassword(appController
                                                                        .passwords
                                                                        .value[index]);
                                                                await appController
                                                                    .uploadedToCloudEdit(
                                                                        password
                                                                            .id,
                                                                        password
                                                                            .cloud_id);
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        settingsController
                                                                            .customSnachBar('Check Network connection'));
                                                              }
                                                            } on HttpException catch (e) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      settingsController
                                                                          .customSnachBar(
                                                                              e.message));
                                                            } catch (e) {
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      settingsController
                                                                          .customSnachBar(
                                                                              'Check Network connection'));
                                                            }
                                                          },
                                                          icon: const Icon(
                                                              Icons.upload,
                                                              color:
                                                                  Colors.white),
                                                        )
                                                  : const SizedBox(
                                                      height: 0, width: 0);
                                            }),
                                            IconButton(
                                              onPressed: () async {
                                                _usernameController.text =
                                                    appController.passwords
                                                        .value[index].username;
                                                final encrypted =
                                                    await cloudController
                                                        .returnDecryptPwd(
                                                            appController
                                                                .passwords
                                                                .value[index]
                                                                .password);
                                                _passwordController.text =
                                                    await cloudController
                                                        .decryptPassword(
                                                            encrypted);
                                                _titleController.text =
                                                    appController.passwords
                                                        .value[index].title;

                                                settingsController
                                                    .messageDialogue(
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              const Text(
                                                                  'Update Account'),
                                                              IconButton(
                                                                onPressed: () {
                                                                  appController
                                                                          .isAdded
                                                                          .value =
                                                                      false;
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons.cancel,
                                                                  color: Colors
                                                                      .pink,
                                                                ),
                                                              )
                                                            ]),
                                                        SizedBox(
                                                          height: 200,
                                                          child: Column(
                                                            // ignore: prefer_const_literals_to_create_immutables
                                                            children: [
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      _usernameController,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colors
                                                                              .green,
                                                                          width:
                                                                              5.0),
                                                                    ),
                                                                    label: Text(
                                                                        'username/email/number'),
                                                                    prefixIcon:
                                                                        Icon(Icons
                                                                            .person),
                                                                  ),
                                                                ),
                                                              ),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            10),
                                                                child:
                                                                    TextField(
                                                                  controller:
                                                                      _passwordController,
                                                                  decoration:
                                                                      const InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderSide: BorderSide(
                                                                          color: Colors
                                                                              .green,
                                                                          width:
                                                                              5.0),
                                                                    ),
                                                                    label: Text(
                                                                        'password'),
                                                                    prefixIcon:
                                                                        Icon(Icons
                                                                            .lock),
                                                                  ),
                                                                  obscureText:
                                                                      true,
                                                                ),
                                                              ),
                                                              TextField(
                                                                controller:
                                                                    _titleController,
                                                                decoration:
                                                                    const InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderSide: BorderSide(
                                                                              color: Colors.green,
                                                                              width: 5.0),
                                                                        ),
                                                                        label: Text(
                                                                            'title'),
                                                                        prefixIcon:
                                                                            Icon(Icons.label)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        [
                                                          Obx(() {
                                                            return appController
                                                                    .isLoading
                                                                    .value
                                                                // ignore: deprecated_member_use
                                                                ? FlatButton(
                                                                    onPressed:
                                                                        () {},
                                                                    child: const CircularProgressIndicator(
                                                                        color: Colors
                                                                            .white),
                                                                  )
                                                                // ignore: deprecated_member_use
                                                                : appController
                                                                        .isAdded
                                                                        .value
                                                                    ? Chip(
                                                                        avatar:
                                                                            const Icon(
                                                                          Icons
                                                                              .done_all,
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                        label: const Text(
                                                                            'Exit'),
                                                                        onDeleted:
                                                                            () {
                                                                          appController
                                                                              .isAdded
                                                                              .value = false;
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      )
                                                                    : RaisedButton(
                                                                        onPressed:
                                                                            () async {
                                                                          if (_usernameController.text.isNotEmpty &&
                                                                              _passwordController.text.isNotEmpty &&
                                                                              _titleController.text.isNotEmpty) {
                                                                            if (_passwordController.text.length >=
                                                                                6) {
                                                                              PasswordStorage passwordStorage = PasswordStorage(id: appController.passwords.value[index].id, title: _titleController.text, username: _usernameController.text, password: _passwordController.text, createAt: appController.passwords.value[index].createAt, updatedAt: appController.passwords.value[index].updatedAt, click: appController.passwords.value[index].click, cloud_id: appController.passwords.value[index].cloud_id, important: appController.passwords.value[index].important, uploaded: appController.passwords.value[index].uploaded);
                                                                              await cloudController.updateRequest(
                                                                                  passwordStorage: passwordStorage,
                                                                                  message: (msg) {
                                                                                    ScaffoldMessenger.of(context).showSnackBar(settingsController.customSnachBar(msg));
                                                                                    _usernameController.text = '';
                                                                                    _passwordController.text = '';
                                                                                    _titleController.text = '';
                                                                                    Navigator.of(context).pop();
                                                                                  });
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(settingsController.customSnachBar('Password Length should be 6 or grater then 6 characters.'));
                                                                            }
                                                                          } else {
                                                                            ScaffoldMessenger.of(context).showSnackBar(settingsController.customSnachBar('Please Enter all values.'));
                                                                          }
                                                                        },
                                                                        child: const Text(
                                                                            'UPDATE'),
                                                                      );
                                                          })
                                                        ],
                                                        4,
                                                        context);
                                              },
                                              icon: const Icon(Icons.edit,
                                                  color: Colors.white),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                settingsController
                                                    .messageDialogue(
                                                        const Text(
                                                            'Do want to continue.'),
                                                        const Text(
                                                            'This password will deleted permanentaly.'),
                                                        [
                                                          RaisedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: Text('NO'),
                                                          ),
                                                          RaisedButton(
                                                            onPressed:
                                                                () async {
                                                              await cloudController
                                                                  .deleteRequest(
                                                                      key: appController
                                                                          .passwords
                                                                          .value[
                                                                              index]
                                                                          .id,
                                                                      cloud_id: appController
                                                                          .passwords
                                                                          .value[
                                                                              index]
                                                                          .cloud_id,
                                                                      message:
                                                                          () {
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(
                                                                          settingsController
                                                                              .customSnachBar('Account has been Deleted.'),
                                                                        );
                                                                      });
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                'YES'),
                                                          )
                                                        ],
                                                        3,
                                                        context);
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.white,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    subtitle: Text(
                                        appController
                                            .passwords.value[index].username,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ))),
                              ),
                              childCount: appController.passwords.value.length,
                            ),
                          )
                        : const SliverToBoxAdapter(
                            child: Center(
                              child: Text('No Passwords Found.'),
                            ),
                          ),
              );
            },
          )
        ],
      ), //atingActionButtonLocation:
      //     FloatingActionButtonLocation.,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          showOptions == true
              ? SlideTransition(
                  position: _position,
                  child: Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Obx(() {
                          return settingsController.uploadCloud.isTrue
                              ? FloatingActionButton(
                                  heroTag: '1',
                                  elevation: 4,
                                  mini: true,
                                  onPressed: () async {
                                    if (await await InternetConnectionChecker()
                                        .hasConnection) {
                                      try {
                                        await cloudController.fullRefresh();
                                        await cloudController
                                            .deleteAllPendingPasswords();
                                      } on HttpException catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(settingsController
                                                .customSnachBar(e.message));
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(settingsController
                                                .customSnachBar(e.toString()));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          settingsController.customSnachBar(
                                              'No Internet found Please Connect to internet.'));
                                    }
                                  },
                                  child: Icon(Icons.refresh),
                                )
                              : Container(
                                  height: 0,
                                  width: 0,
                                  color: Colors.transparent,
                                );
                        }),
                        FloatingActionButton(
                          heroTag: '0',
                          elevation: 4,
                          mini: true,
                          onPressed: () {
                            widget.drawerAnimation.reset();
                            widget.setPosition(-1.0, 0.0, 0.0, 0.0);
                            widget.drawerAnimation.forward();
                            widget.openDrawer();
                          },
                          child: Icon(Icons.info_outline),
                        ),
                        FloatingActionButton(
                          heroTag: '2',
                          elevation: 4,
                          mini: true,
                          onPressed: () {
                            settingsController.rightSlidePage(
                                context, SearchScreen());
                          },
                          child: Icon(Icons.search),
                        ),
                        FloatingActionButton(
                          heroTag: '3',
                          elevation: 4,
                          mini: true,
                          onPressed: () {
                            settingsController.rightSlidePage(
                                context, SettingsScreen());
                          },
                          child: Icon(Icons.settings),
                        ),
                        FloatingActionButton(
                          heroTag: '4',
                          mini: true,
                          onPressed: () {
                            settingsController.messageDialogue(
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Create Password'),
                                      IconButton(
                                        onPressed: () {
                                          appController.isAdded.value = false;
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.pink,
                                        ),
                                      )
                                    ]),
                                SizedBox(
                                  height: 200,
                                  child: Column(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: TextField(
                                          controller: _usernameController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 5.0),
                                            ),
                                            label:
                                                Text('username/email/number'),
                                            prefixIcon: Icon(Icons.person),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: TextField(
                                          controller: _passwordController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 5.0),
                                            ),
                                            label: Text('password'),
                                            prefixIcon: Icon(Icons.lock),
                                          ),
                                          obscureText: true,
                                        ),
                                      ),
                                      TextField(
                                        controller: _titleController,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green,
                                                  width: 5.0),
                                            ),
                                            label: Text('title'),
                                            prefixIcon: Icon(Icons.label)),
                                      )
                                    ],
                                  ),
                                ),
                                [
                                  Obx(() {
                                    return appController.isLoading.value
                                        // ignore: deprecated_member_use
                                        ? FlatButton(
                                            onPressed: () {},
                                            child:
                                                const CircularProgressIndicator(
                                                    color: Colors.white),
                                          )
                                        // ignore: deprecated_member_use
                                        : appController.isAdded.value
                                            ? Chip(
                                                avatar: const Icon(
                                                  Icons.done_all,
                                                  color: Colors.green,
                                                ),
                                                label:
                                                    const Text('ADD ANOTHER'),
                                                onDeleted: () {
                                                  _usernameController.text = '';
                                                  _passwordController.text = '';
                                                  _titleController.text = '';
                                                  appController.isAdded.value =
                                                      false;
                                                },
                                              )
                                            : RaisedButton(
                                                onPressed: () async {
                                                  if (_usernameController.text.isNotEmpty &&
                                                      _passwordController
                                                          .text.isNotEmpty &&
                                                      _titleController
                                                          .text.isNotEmpty) {
                                                    if (_passwordController
                                                            .text.length >=
                                                        6) {
                                                      try {
                                                        await cloudController
                                                            .storePassword(
                                                                _titleController
                                                                    .text,
                                                                _usernameController
                                                                    .text,
                                                                _passwordController
                                                                    .text);
                                                        _usernameController
                                                            .text = '';
                                                        _passwordController
                                                            .text = '';
                                                        _titleController.text =
                                                            '';
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                settingsController
                                                                    .customSnachBar(
                                                                        'Password Created.'));
                                                      } on HttpException catch (e) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                settingsController
                                                                    .customSnachBar(
                                                                        e.message));
                                                      } catch (e) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                settingsController
                                                                    .customSnachBar(
                                                                        'Network error.'));
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              settingsController
                                                                  .customSnachBar(
                                                                      'Password Length should be 6 or grater then 6 characters.'));
                                                    }
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                            settingsController
                                                                .customSnachBar(
                                                                    'Please Enter all values.'));
                                                  }
                                                },
                                                child: const Text('SAVE'),
                                              );
                                  })
                                ],
                                4,
                                context);
                          },
                          child: const Icon(Icons.add),
                          elevation: 4,
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 0,
                  width: 0,
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0)),
          FloatingActionButton(
            heroTag: '5',
            onPressed: () {
              changeValue();
            },
            child: Icon(showOptions ? Icons.cancel : Icons.add),
          ),
        ],
      ),
    );
  }
}
