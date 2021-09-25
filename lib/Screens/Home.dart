// ignore_for_file: file_names, unnecessary_null_comparison
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:password_manager/Screens/fileShare_manager/file_screens.dart';
import 'package:password_manager/Screens/links_manager/links_screen.dart';
import 'package:password_manager/Screens/password_manager/password_screen.dart';
import 'package:password_manager/src/Controllers/settings_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Future<bool> exitApp() {
    exit(0);
  }

  double xOffset = 0;
  double yOffset = 0;
  double scaleFacor = 1;
  late Animation<Offset> _position;
  late AnimationController _controller;

  openHiddenDrawer() {
    setState(() {
      xOffset = 250;
      yOffset = 120;
      scaleFacor = 0.7;
    });
  }

  closeHiddenDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFacor = 1;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _position = Tween<Offset>(begin: Offset(0.0, 0.0), end: Offset(0.0, 0.0))
        .animate(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  setPosition(startx, starty, endx, endy) {
    setState(() {
      _position =
          Tween<Offset>(begin: Offset(startx, starty), end: Offset(endx, endy))
              .animate(_controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    SettingsController settingsController = Get.find<SettingsController>();
    return WillPopScope(
      child: PageView(
        children: [
          Stack(
            children: [
              Obx(() {
                return Scaffold(
                  backgroundColor: settingsController.theme.value == 'light'
                      ? Color(0xff416d6d)
                      : Colors.black54,
                  body: SlideTransition(
                    position: _position,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'App Information',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25),
                              ),
                              IconButton(
                                onPressed: () {
                                  setPosition(1.0, 0.0, 0.0, 0.0);
                                  _controller.reset();
                                  _controller.forward();
                                  closeHiddenDrawer();
                                },
                                icon: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            await launch('https://flutter.dev/');
                          },
                          leading: const Icon(
                            Icons.engineering,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Google Flutter',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: const Text(
                            'Developed in google flutter',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: Icon(
                            Icons.rate_review,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Feedback',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            'Drop your feedback',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            await launch(
                                'https://github.com/ByteCode-Club/password_manager_flutter');
                          },
                          leading: const Icon(
                            Icons.folder,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Source code',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: const Text(
                            'Get full source code',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () {},
                          leading: const Icon(
                            Icons.android,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'More Apps',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: const Text(
                            'Download our apps',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text(
                                'Developer',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25),
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            launch('https://github.com/frenzycoder7');
                          },
                          leading: const Icon(
                            Icons.code,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'frenzycoder7',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: const Text(
                            'GitHub',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            await launch(
                                'https://www.linkedin.com/in/gaurav-singh-952841195');
                          },
                          leading: const Icon(
                            Icons.link,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'Gaurav Singh',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: const Text(
                            'LinkedIn',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            final url =
                                'mailto:gs9178449@gmail.com?subject=${Uri.encodeFull('For Work')}&body=${Uri.encodeFull('Hello Gaurav')}';
                            await launch(url);
                          },
                          leading: const Icon(
                            Icons.email,
                            color: Colors.white,
                          ),
                          title: const Text(
                            'gs9178449@gmail.com',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: const Text(
                            'Gmail',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            await launch('tel:+91 9262715527');
                          },
                          leading: const Icon(
                            Icons.phone,
                            color: Colors.white,
                          ),
                          title: const Text(
                            '+91 9262715527',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: const Text(
                            'Number',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              AnimatedContainer(
                //decoration: decoration,
                //clipBehavior: ,
                transform: Matrix4.translationValues(xOffset, yOffset, 0)
                  ..scale(scaleFacor),
                duration: Duration(microseconds: 250),
                curve: Curves.easeIn,
                child: SlideTransition(
                  position: _position,
                  child: PasswordScreen(
                    openDrawer: openHiddenDrawer,
                    drawerAnimation: _controller,
                    setPosition: setPosition,
                  ),
                ),
              ),
            ],
          ),
          LinksManager(),
          FileScreen(),
        ],
      ),
      onWillPop: exitApp,
    );
  }
}
