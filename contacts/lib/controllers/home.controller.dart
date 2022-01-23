import 'package:contacts/models/contact.model.dart';
import 'package:contacts/repositories/contact.repository.dart';
import 'package:mobx/mobx.dart';
part 'home.controller.g.dart';

class HomeController = _HomeController with _$HomeController;

//store vai servir também para gerenciar o estado se está buscando ou não
//porque vai ser criado um widget separado da appbar, e o setstate não funciona
//bem para gerenciar estado entre widgets

abstract class _HomeController with Store {
  @observable
  bool showSearch = false;

  @observable
  ObservableList<ContactModel> contacts = new ObservableList<ContactModel>();

  @action
  toggleSearch() {
    showSearch = !showSearch;
  }

  @action
  search(String term) async {
    contacts.clear();
    final repository = new ContactRepository();
    var result = await repository.search(term);
    contacts.addAll(result);
  }
}
