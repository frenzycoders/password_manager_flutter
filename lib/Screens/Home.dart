// ignore_for_file: file_names, unnecessary_null_comparison

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/src/controller.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppController appController = Get.find<AppController>();
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            Obx(() {
              return SliverAppBar(
                toolbarHeight: 60,
                title: appController.isSearch.isTrue
                    ? TextField(
                        onChanged: (value) {
                          appController.filterByIndex(value);
                        },
                        decoration: const InputDecoration(
                          label: Text('type username..'),
                          prefixIcon: Icon(Icons.search),
                        ),
                      )
                    : Text('Password Manager'),
                actions: [
                  appController.isSearch.isFalse
                      ? IconButton(
                          onPressed: () {
                            appController.enableSearchBar();
                          },
                          icon: const Icon(Icons.search,color: Colors.blueGrey,))
                      : Container(),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: appController.isSearch.isTrue
                        ? IconButton(
                            onPressed: () {
                              appController.fetchPasswords();
                              appController.disableSearchBar();
                            },
                            icon: const Icon(Icons.remove,color: Colors.blueGrey,),
                          )
                        : appController.theme == 'light'
                            ? IconButton(
                                onPressed: () {
                                  appController.changeToDark();
                                },
                                icon: const Icon(Icons.nightlight_round,
                                    color: Colors.pink),
                              )
                            : IconButton(
                                onPressed: () {
                                  appController.changeToLight();
                                },
                                icon: const Icon(
                                  Icons.wb_sunny,
                                  color: Colors.yellowAccent,
                                ),
                              ),
                  )
                ],
                expandedHeight: 50,
                //stretch: true,
                onStretchTrigger: (() {
                  print('Hy');
                })(),
                flexibleSpace: FlexibleSpaceBar(
                  // ignore: unrelated_type_equality_checks
                  title: Obx(() {
                    return Text(
                      'Keep your passwords with you.',
                      style: TextStyle(
                          fontSize: 10,
                          // ignore: unrelated_type_equality_checks
                          color: appController.theme == 'light'
                              ? Colors.blueGrey
                              : Colors.white70),
                    );
                  }),
                  titlePadding: const EdgeInsets.only(left: 20),
                ),
              );
            }),
            Obx(
              () {
                return SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: appController.passwords.value.length > 0
                        ? SliverFixedExtentList(
                            itemExtent: 85.0,
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => Card(
                                elevation: 3,
                                color: appController.theme == 'light' ? Colors.white70 : Colors.blueGrey,
                                child: ListTile(
                                    //leading: const Icon(Icons.person),
                                    onTap: () {
                                      FlutterClipboard.copy(appController
                                              .passwords.value[index].password)
                                          .then((value) {
                                        ScaffoldMessenger.maybeOf(context)!
                                            .showSnackBar(
                                          appController
                                              .customSnachBar('Password copied.'),
                                        );
                                        appController.increaseCount(appController
                                            .passwords.value[index].id);
                                      });
                                    },
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            appController
                                                .passwords.value[index].title,
                                            overflow: TextOverflow.ellipsis),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _usernameController.text =
                                                    appController.passwords
                                                        .value[index].username;
                                                _passwordController.text =
                                                    appController.passwords
                                                        .value[index].password;
                                                _titleController.text =
                                                    appController.passwords
                                                        .value[index].title;

                                                appController.messageDialogue(
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
                                                                  .value = false;
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
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
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 10),
                                                            child: TextField(
                                                              controller:
                                                                  _usernameController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .green,
                                                                      width: 5.0),
                                                                ),
                                                                label: Text(
                                                                    'username/email/number'),
                                                                prefixIcon: Icon(
                                                                    Icons.person),
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 10),
                                                            child: TextField(
                                                              controller:
                                                                  _passwordController,
                                                              decoration:
                                                                  const InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide: BorderSide(
                                                                      color: Colors
                                                                          .green,
                                                                      width: 5.0),
                                                                ),
                                                                label: Text(
                                                                    'password'),
                                                                prefixIcon: Icon(
                                                                    Icons.lock),
                                                              ),
                                                              obscureText: true,
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
                                                                          color: Colors
                                                                              .green,
                                                                          width:
                                                                              5.0),
                                                                    ),
                                                                    label: Text(
                                                                        'title'),
                                                                    prefixIcon:
                                                                        Icon(Icons
                                                                            .label)),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    [
                                                      Obx(() {
                                                        return appController
                                                                .isLoading.value
                                                            // ignore: deprecated_member_use
                                                            ? FlatButton(
                                                                onPressed: () {},
                                                                child: const CircularProgressIndicator(
                                                                    color: Colors
                                                                        .white),
                                                              )
                                                            // ignore: deprecated_member_use
                                                            : appController
                                                                    .isAdded.value
                                                                ? Chip(
                                                                    avatar:
                                                                        const Icon(
                                                                      Icons
                                                                          .done_all,
                                                                      color: Colors
                                                                          .green,
                                                                    ),
                                                                    label:
                                                                        const Text(
                                                                            'Exit'),
                                                                    onDeleted:
                                                                        () {
                                                                      appController
                                                                          .isAdded
                                                                          .value = false;
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  )
                                                                : RaisedButton(
                                                                    onPressed:
                                                                        () {
                                                                      if (_usernameController.text.isNotEmpty &&
                                                                          _passwordController
                                                                              .text
                                                                              .isNotEmpty &&
                                                                          _titleController
                                                                              .text
                                                                              .isNotEmpty) {
                                                                        appController.editDataToStorage(
                                                                            appController
                                                                                .passwords
                                                                                .value[
                                                                                    index]
                                                                                .id,
                                                                            _titleController
                                                                                .text,
                                                                            _usernameController
                                                                                .text,
                                                                            _passwordController
                                                                                .text);
                                                                      } else {
                                                                        ScaffoldMessenger.of(
                                                                                context)
                                                                            .showSnackBar(
                                                                                appController.customSnachBar('Please Enter all values.'));
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
                                              icon: const Icon(Icons.edit),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                appController.messageDialogue(
                                                    const Text(
                                                        'Do want to continue.'),
                                                    const Text(
                                                        'This password will deleted permanentaly.'),
                                                    [
                                                      RaisedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('NO'),
                                                      ),
                                                      RaisedButton(
                                                        onPressed: () {
                                                          appController
                                                              .deletePassword(
                                                                  appController
                                                                      .passwords
                                                                      .value[
                                                                          index]
                                                                      .id);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                            appController
                                                                .customSnachBar(
                                                                    'Account has been Deleted.'),
                                                          );
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text('YES'),
                                                      )
                                                    ],
                                                    3,
                                                    context);
                                              },
                                              icon: const Icon(Icons.delete),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    subtitle: Text(
                                      appController
                                          .passwords.value[index].username,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                              ),
                              childCount: appController.passwords.value.length,
                            ),
                          )
                        : const SliverToBoxAdapter(
                            child: Center(
                            child: Text('No Passwords Found.'),
                          )));
              },
            )
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          appController.messageDialogue(
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 5.0),
                          ),
                          label: Text('username/email/number'),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 5.0),
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
                            borderSide:
                                BorderSide(color: Colors.green, width: 5.0),
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
                          child: const CircularProgressIndicator(
                              color: Colors.white),
                        )
                      // ignore: deprecated_member_use
                      : appController.isAdded.value
                          ? Chip(
                              avatar: const Icon(
                                Icons.done_all,
                                color: Colors.green,
                              ),
                              label: const Text('ADD ANOTHER'),
                              onDeleted: () {
                                _usernameController.text = '';
                                _passwordController.text = '';
                                _titleController.text = '';
                                appController.isAdded.value = false;
                              },
                            )
                          : RaisedButton(
                              onPressed: () {
                                if (_usernameController.text.isNotEmpty &&
                                    _passwordController.text.isNotEmpty &&
                                    _titleController.text.isNotEmpty) {
                                  appController.addDataToStorage(
                                      _titleController.text,
                                      _usernameController.text,
                                      _passwordController.text);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      appController.customSnachBar(
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
      ),
    );
  }
}
