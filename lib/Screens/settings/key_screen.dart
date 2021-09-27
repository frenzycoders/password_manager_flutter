import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get.dart';
import 'package:password_manager/src/Controllers/cloud_controller.dart';
import 'package:password_manager/src/Controllers/settings_controller.dart';

class KeyScreen extends StatelessWidget {
  KeyScreen({Key? key}) : super(key: key);
  TextEditingController _keyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SettingsController appController = Get.find<SettingsController>();
    CloudController cloudController = Get.find<CloudController>();
    return Scaffold(
      body: Obx(() {
        return CustomScrollView(
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
              title: const Text('Key Manager'),
              expandedHeight: 50,
            ),
            SliverToBoxAdapter(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Your Key',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await cloudController.copyString(
                                      cloudController.profile.value.eKey, () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        appController
                                            .customSnachBar('eKey copied'));
                                  });
                                },
                                icon: Icon(Icons.copy),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(15),
                          color: appController.theme.value == 'light'
                              ? Color(0xff416d6d)
                              : Colors.black,
                          child: Text(
                            cloudController.profile.value.eKey,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 15, left: 15, right: 15),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: RaisedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              appController.customSnachBar(
                                                  'Comming soon...'));
                                    },
                                    color: appController.theme.value == 'light'
                                        ? Colors.green
                                        : Color(0xff416d6d),
                                    child: Container(
                                      height: 50,
                                      alignment: Alignment.center,
                                      child: Text(
                                        'NEW KEY',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: RaisedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                              appController.customSnachBar(
                                                  'Comming soon..'));
                                    },
                                    color: appController.theme.value == 'light'
                                        ? Color(0xff416d6d)
                                        : Colors.green,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      child: Text(
                                        'SAVE',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.only(top: 10),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Add Old eKey',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  appController.messageDialogue(
                                      Text('What is old eKey ?'),
                                      RichText(
                                        text: TextSpan(text: "OLD ", children: [
                                          TextSpan(
                                            text:
                                                "Key which was provided by password manager on your last login or registration",
                                          )
                                        ]),
                                      ),
                                      [
                                        RaisedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('CANCLE')),
                                      ],
                                      24,
                                      context);
                                },
                                icon: Icon(Icons.info),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          color: appController.theme.value == 'light'
                              ? Color(0xff416d6d)
                              : Colors.black,
                          child: TextField(
                            controller: _keyController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.green, width: 5.0),
                              ),
                              label: Text(
                                'Your old Key',
                                style: TextStyle(color: Colors.white),
                              ),
                              prefixIcon: Icon(Icons.lock, color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: RaisedButton(
                            onPressed: () {
                              appController.messageDialogue(
                                  const Text('Do you want to continue ?'),
                                  RichText(
                                    text: TextSpan(text: "WARNING ", children: [
                                      TextSpan(
                                          text:
                                              "After updating your new eKey with your old eKey. you can't access your passwords which was created and encrypted with new eKey . If your passwords are encrypted with your old eKey then you can continue this process. Keep remember your eKey. don't add any other password otherwise this can delete your passwords.")
                                    ]),
                                  ),
                                  [
                                    RaisedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('CANCLE')),
                                    RaisedButton(
                                        onPressed: () {
                                          if (_keyController.text.length > 20) {
                                            cloudController.ChangeKey(
                                                _keyController.text);
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(appController
                                                    .customSnachBar(
                                                        'eKey updated success...'));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(appController
                                                    .customSnachBar(
                                                        'Wrong eKey'));
                                          }
                                        },
                                        child: Text('UPDATE NOW'))
                                  ],
                                  24,
                                  context);
                            },
                            color: appController.theme.value == 'light'
                                ? Color(0xff416d6d)
                                : Colors.green,
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                'UPDATE KEY',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}
