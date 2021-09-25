import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:password_manager/src/Controllers/cloud_controller.dart';
import 'package:password_manager/src/Controllers/settings_controller.dart';
import 'package:password_manager/src/HttpException.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  late Animation<Offset> _position;
  late AnimationController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 700),
    );
    _position = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(_controller);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textEditingController.dispose();
    _otpController.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SettingsController settingsController = Get.find<SettingsController>();
    CloudController apiController = Get.find<CloudController>();
    _controller.forward();
    return Scaffold(
      body: CustomScrollView(
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
                return settingsController.theme.value == 'light'
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
            title: const Text('Join'),
            // title: const Text('Create / Verify your space'),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: settingsController.theme.value == 'light'
                  ? Colors.green.shade50
                  : Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: SizedBox(
                  height: 180,
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 50,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Image(
                              image: AssetImage('assets/logo.png'),
                            ),
                          ),
                        ),
                        const Align(
                          //alignment: Alignment.center,
                          child: Text(
                            'Your all encrypted passwords will be uploaded to server. Which can only decrypt by key stored in local storage of your device.',
                            style: TextStyle(
                                color: Colors.grey,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w500),
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Privacy Information:- ',
                      style: TextStyle(
                        color: Colors.indigoAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'Generated key is responsible for encrypt and decrypt your passwords in your device. Password Manager do not store your key also you can change your key any time. Also you can create your custom key.',
                      style: TextStyle(
                        color: Colors.green,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.fade,
                      ),
                      // textAlign: TextAlign.justify,
                      // overflow: TextOverflow.fade,
                      // softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              child: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Warning:- ',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text:
                          'If your key was forgotten then in this case you can get your encrypted password but your device is not able to decrypt it.',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                        overflow: TextOverflow.fade,
                      ),
                      // textAlign: TextAlign.justify,
                      // overflow: TextOverflow.fade,
                      // softWrap: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(() {
            return apiController.otpVerification.isFalse
                ? SliverToBoxAdapter(
                    child: SlideTransition(
                      position: _position,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: TextField(
                          controller: _textEditingController,
                          decoration: const InputDecoration(
                            hintText: 'Your Email',
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.orange,
                            ),
                            // icon: Icon(Icons.person),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : SliverToBoxAdapter(
                    child: SlideTransition(
                      position: _position,
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 250,
                        child: ListView(
                          children: [
                            const Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                'ENTER OTP',
                                style: TextStyle(
                                  //color: Colors.blueGrey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      'Enter One time password for verification send on your email. \n',
                                  children: [
                                    TextSpan(
                                      text: apiController.profile.value.email,
                                      style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                _controller.reset();
                                await apiController.wrongEmail();
                                _controller.forward();
                              },
                              child: Text('Wrong email ?'),
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: TextField(
                                maxLength: 6,
                                keyboardType: TextInputType.number,
                                controller: _otpController,
                                decoration: const InputDecoration(
                                  hintText: 'Enter OTP',
                                  prefixIcon: Icon(
                                    Icons.verified_rounded,
                                    color: Colors.orange,
                                  ),
                                  // icon: Icon(Icons.person),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.0),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
          }),
          Obx(() {
            return SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.all(20),
                child: apiController.otpVerification.isTrue
                    ? SlideTransition(
                        position: _position,
                        child: Container(
                          height: 56,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: RaisedButton(
                                    onPressed: () {},
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      child: Text('Resend'),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: RaisedButton(
                                    onPressed: () async {
                                      if (apiController.isLoading.isFalse) {
                                        try {
                                          if (_otpController.text.length == 6) {
                                            await apiController.verifyUser(
                                                otp: _otpController.text);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              settingsController.customSnachBar(
                                                  'You are Connected to server'),
                                            );
                                            Navigator.of(context).pop();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(settingsController
                                                    .customSnachBar(
                                                        'Please Enter 6 digit OTP.'));
                                          }
                                        } on HttpException catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(settingsController
                                                  .customSnachBar(e.message));
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(settingsController
                                                  .customSnachBar(
                                                      e.toString()));
                                        }
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 50,
                                      child: apiController.isLoading.isFalse
                                          ? const Text('Verify')
                                          : const CircularProgressIndicator(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : RaisedButton(
                        color: Colors.orangeAccent,
                        onPressed: () async {
                          if (apiController.otpVerification.isTrue) {
                          } else {
                            try {
                              _controller.reset();
                              if (_textEditingController.text.isNotEmpty) {
                                await apiController.createSpace(
                                    email: _textEditingController.text);
                                _controller.forward();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    settingsController
                                        .customSnachBar('Please Enter email'));
                              }
                            } on HttpException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  settingsController.customSnachBar(e.message));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  settingsController.customSnachBar(
                                      'Check your internet Connection.'));
                            }
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          child: apiController.isLoading.isTrue
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'NEXT',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
              ),
            );
          })
        ],
      ),
    );
  }
}
