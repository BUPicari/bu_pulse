import 'package:bu_pulse/data/resources/offline/api_to_db_provider.dart';

class ApiToDbRepository {
  final _provider = ApiToDbProvider();

  Future<void> insertAllDataFromApiToLocalDB() async {
    await _provider.insertData();
    // await _provider.getAddressesDropdown();
    await _provider.getCoursesDropdown();
    await _provider.getSchoolsDropdown(page: 1);
  }
}
