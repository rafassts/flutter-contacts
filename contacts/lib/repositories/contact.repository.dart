import 'package:contacts/models/contact.model.dart';
import 'package:contacts/settings.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ContactRepository {
  Future<Database> _getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), DATABASE_NAME),
      onCreate: (db, version) async {
        return db.execute(CREATE_TABLE_CONTACTS);
      },
      version: 1,
    );
  }

  Future create(ContactModel model) async {
    try {
      final Database db = await _getDatabase();
      await db.insert(
        TABLE_CONTACTS,
        model.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future update(ContactModel model) async {
    try {
      final db = await _getDatabase();
      await db.update(
        TABLE_CONTACTS,
        model.toJson(),
        where: "id = ?",
        whereArgs: [model.id],
      );
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future updateImage(int id, String imagePath) async {
    try {
      final db = await _getDatabase();
      final model = await getContactById(id);

      model.image = imagePath;

      await db.update(TABLE_CONTACTS, model.toJson(),
          where: "id = ?", whereArgs: [model.id]);
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future updateAddress(
      int id, String addressLine1, String addressLine2, String latLng) async {
    try {
      final db = await _getDatabase();
      final model = await getContactById(id);

      model.addressLine1 = addressLine1;
      model.addressLine2 = addressLine2;
      model.latLng = latLng;

      await db.update(TABLE_CONTACTS, model.toJson(),
          where: "id = ?", whereArgs: [model.id]);
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future delete(int id) async {
    try {
      final db = await _getDatabase();
      await db.delete(TABLE_CONTACTS, where: "id = ?", whereArgs: [id]);
    } catch (ex) {
      print(ex);
      return;
    }
  }

  Future<List<ContactModel>> getContacts() async {
    try {
      final Database db = await _getDatabase();
      final List<Map<String, dynamic>> maps = await db.query(TABLE_CONTACTS);
      return List.generate(maps.length, (index) {
        return ContactModel.fromJson(maps[index]);
      });
    } catch (ex) {
      print(ex);
      return <ContactModel>[];
    }
  }

  Future<List<ContactModel>> search(String name) async {
    try {
      final Database db = await _getDatabase();

      final List<Map<String, dynamic>> maps =
          await db.query(TABLE_CONTACTS, where: "name LIKE ? ", whereArgs: [
        '%$name%',
      ]);

      return List.generate(maps.length, (index) {
        return ContactModel.fromJson(maps[index]);
      });
    } catch (ex) {
      print(ex);
      return <ContactModel>[];
    }
  }

  Future<ContactModel> getContactById(int id) async {
    try {
      final db = await _getDatabase();
      var contact =
          await db.query(TABLE_CONTACTS, where: "id = ?", whereArgs: [id]);
      return ContactModel.fromJson(contact[0]);
    } catch (ex) {
      print(ex);
      return _generateEmptyContact();
    }
  }

  ContactModel _generateEmptyContact() {
    return new ContactModel(
        id: 0,
        name: "",
        email: "",
        phone: "",
        image: "",
        addressLine1: "",
        addressLine2: "",
        latLng: "");
  }
}
