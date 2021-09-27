// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/Screens/Cloud/register_screen.dart';
import 'package:password_manager/Screens/settings/PinCreate.dart';
import 'package:password_manager/Screens/settings/key_screen.dart';
import 'package:password_manager/src/Config.dart';
import 'package:password_manager/src/Controllers/cloud_controller.dart';
import 'package:password_manager/src/Controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SettingsController appController = Get.find<SettingsController>();
    CloudController cloudController = Get.find<CloudController>();
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
              title: Text('Settings'),
              expandedHeight: 50,
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 10),
              sliver: SliverToBoxAdapter(
                child: Obx(() {
                  return ListTile(
                    enabled: appController.isBioMetric.isTrue ? true : false,
                    leading: const Icon(Icons.fingerprint),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Fingerprint security.'),
                        Switch(
                          value: appController.fingerLock.value,
                          onChanged: (value) {
                            appController.enableFingrePrint();
                          },
                        )
                      ],
                    ),
                    subtitle: const Text(
                        'Fingrepring authentication required for each restart.'),
                  );
                }),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 10),
              sliver: SliverToBoxAdapter(
                child: Obx(() {
                  return ListTile(
                    enabled: true,
                    leading: const Icon(Icons.nightlight),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Dark Mode'),
                        Switch(
                          value: appController.theme.value == 'dark',
                          onChanged: (value) {
                            appController.theme.value == 'dark'
                                ? appController.changeToLight()
                                : appController.changeToDark();
                          },
                        )
                      ],
                    ),
                    subtitle: const Text('Switch theme mode'),
                  );
                }),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 10),
              sliver: SliverToBoxAdapter(
                child: Obx(() {
                  return ListTile(
                    enabled: appController.faceBioMetric.isTrue ? true : false,
                    leading: const Icon(Icons.face_unlock_outlined),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Facelock'),
                        appController.faceBioMetric.isTrue
                            ? Switch(
                                value: appController.facelock.value,
                                onChanged: (value) {
                                  appController.enableFaceLock();
                                },
                              )
                            : Container(),
                      ],
                    ),
                    subtitle: const Text(
                        'face authentication required for each restart.'),
                  );
                }),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 10),
              sliver: SliverToBoxAdapter(
                child: Obx(() {
                  return ListTile(
                    enabled: true,
                    leading: const Icon(Icons.password),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('PIN'),
                        Switch(
                          value: appController.pinlock.value,
                          onChanged: (value) {
                            if (appController.pinlock.isTrue) {
                              appController.enablePinLogin();
                            } else {
                              appController.rightSlidePage(
                                  context, PinCreate());
                            }
                            //appController.enablePinLogin();
                          },
                        )
                      ],
                    ),
                    subtitle: const Text(
                        'PIN authentication required for each restart.'),
                  );
                }),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                  top: 20, left: 10, right: 10, bottom: 10),
              sliver: SliverToBoxAdapter(
                child: Obx(() {
                  return ListTile(
                    enabled: true,
                    leading: const Icon(Icons.cloud_circle),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Upload to cloud'),
                        Switch(
                          value: appController.uploadCloud.value,
                          onChanged: (value) {
                            if (appController.uploadCloud.isTrue) {
                              appController.enableDisableUploadToCloud();
                            } else {
                              appController.rightSlidePage(
                                  context, RegisterScreen());
                            }
                          },
                        )
                      ],
                    ),
                    subtitle: Text(
                      appController.uploadCloud.isTrue
                          ? 'Uploading Your Passwords to ' +
                              AppConfig.baseUrl.toString()
                          : 'Start Cloud backup of paswords on ' +
                              AppConfig.baseUrl,
                    ),
                  );
                }),
              ),
            ),
            SliverPadding(
              padding:
                  EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
              sliver: SliverToBoxAdapter(
                child: ListTile(
                  enabled:
                      cloudController.profile.value.eKey != '' ? true : false,
                  onTap: () {
                    appController.rightSlidePage(context, KeyScreen());
                  },
                  leading: Icon(Icons.lock),
                  title: Text('Your Key'),
                  subtitle: Text('Your Password is encrypted with eKey "' +
                      cloudController.profile.value.eKey +
                      '" Tap for download key in file formate or change eKey'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
