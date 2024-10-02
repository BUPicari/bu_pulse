import 'package:bu_pulse/data/models/online/dropdown_model.dart';
import 'package:bu_pulse/data/resources/online/dropdown/dropdown_provider.dart';
import 'package:bu_pulse/helpers/variables.dart';

class DropdownRepository {
  final _provider = DropdownProvider();

  Future<Dropdown> getDropdownList({
    required String path,
    required int page,
    required String filter,
    required String q,
  }) {
    return _provider.getDropdownList(
      path: path,
      page: page,
      filter: filter,
      q: q,
    );
  }
}
