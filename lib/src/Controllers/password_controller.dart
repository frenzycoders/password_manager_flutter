import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:password_manager/src/models/password_storage.dart';
import 'package:password_manager/src/models/updated_passwords.dart';
import 'package:password_manager/src/models/deleted_passwords.dart';

class PasswordController extends GetxController {
  String storage = 'password';
  String deleted = 'deleted_passwords';
  String updated = 'updated_passwords';
  late Box<PasswordStorage> passwordBox;
  late Box<UpdatedPasswords> updatedPasswordBox;
  late Box<DeletedPasswords> deletedPasswordBox;
  RxBool isLoading = false.obs;
  RxBool isAdded = false.obs;
  RxList passwords = [].obs;
  RxList pendingUpdatePasswords = [].obs;
  RxList pendingDeletePasswords = [].obs;

  PasswordController() {
    passwordBox = Hive.box<PasswordStorage>(storage);
    updatedPasswordBox = Hive.box<UpdatedPasswords>(updated);
    deletedPasswordBox = Hive.box<DeletedPasswords>(deleted);
    fetchPasswords();
    fetchPendingUpdatedPassword();
    fetchPendingDeletePasswords();
  }

  fetchPasswords() async {
    List list = passwordBox.values.toList();
    // ignore: prefer_is_empty
    if (list.length > 0) list.sort((a, b) => b.click.compareTo(a.click));
    passwords.value = list;
  }

  fetchPendingUpdatedPassword() async {
    List updated = updatedPasswordBox.values.toList();
    pendingUpdatePasswords.value = updated;
  }

  fetchPendingDeletePasswords() async {
    List deleted = deletedPasswordBox.values.toList();
    pendingDeletePasswords.value = deleted;
  }

  Future<PasswordStorage> addDataToStorage(
      String title, String username, String password) async {
    isLoading.value = true;
    final currentTime = DateTime.now().toString();
    PasswordStorage passwordStorage = PasswordStorage(
      id: currentTime + "-" + username,
      title: title,
      username: username,
      password: password,
      createAt: currentTime,
      updatedAt: currentTime,
    );
    passwordBox.put(currentTime + "-" + username, passwordStorage);
    fetchPasswords();
    isAdded.value = true;
    isLoading.value = false;
    return passwordStorage;
  }

  deletePassword(id) {
    passwordBox.delete(id);
    fetchPasswords();
  }

  editDataToStorage(String id, String title, String username, String password) {
    isLoading.value = true;

    final currentTime = DateTime.now().toString();
    PasswordStorage passwordStorage = PasswordStorage(
      id: id,
      title: title,
      username: username,
      password: password,
      createAt: currentTime,
      updatedAt: currentTime,
    );
    passwordBox.put(id, passwordStorage);
    isAdded.value = true;
    isLoading.value = false;
    fetchPasswords();
  }

  updatePasswordWithFullData(PasswordStorage passwordStorage) async {
    passwordStorage.updatedAt = DateTime.now().toString();
    passwordBox.put(passwordStorage.id, passwordStorage);
    await fetchPasswords();
  }

  uploadedToCloudEdit(id, cloud_id) async {
    PasswordStorage passwordStorage = passwordBox.get(id) as PasswordStorage;
    passwordStorage.cloud_id = cloud_id;
    passwordStorage.uploaded = true;
    passwordBox.put(id, passwordStorage);
    fetchPasswords();
  }

  increaseCount(id) {
    PasswordStorage passwordStorage = passwordBox.get(id) as PasswordStorage;
    passwordStorage.click = passwordStorage.click + 1;
    passwordBox.put(passwordStorage.id, passwordStorage);
    fetchPasswords();
  }

  filterByIndex(value) {
    List data = passwordBox.values.toList();
    List n = [];
    n = [];
    for (var element in data) {
      // ignore: avoid_print
      for (int i = 0; i < value.length; i++) {
        if (value[i] == element.username[i]) {
          n.add(element);
        }
      }
    }
    if (n.isNotEmpty) {
      passwords.value = [];
      passwords.value = n;
    } else {
      passwords.value = [];
    }
  }

  cleanFullPasswordStorage() async {
    await passwordBox.clear();
  }

  createIncomingPasswordsFromServer(
      {required PasswordStorage passwordStorage}) {
    passwordBox.put(passwordStorage.id, passwordStorage);
    fetchPasswords();
  }

  addPasswordToUpdatedPasswordBox(UpdatedPasswords updatedPasswords) async {
    updatedPasswordBox.put(updatedPasswords.id, updatedPasswords);
  }

  deleteSinglePasswordFromUpdatedPasswordBox({required String id}) async {
    updatedPasswordBox.delete(id);
  }

  clearUpdatedPasswordBox() async {
    updatedPasswordBox.clear();
  }

  addPendigDeletePassword(DeletedPasswords deletedPasswords) async {
    deletedPasswordBox.put(deletedPasswords.id, deletedPasswords);
  }

  clearPendingDeleteBox() async {
    deletedPasswordBox.clear();
  }
}
