import '../models/deal_model.dart';
import '../data_sources/deal_local_data_source.dart';

class DealRepository {
  final DealLocalDataSource localDataSource;

  DealRepository(this.localDataSource);

  Future<List<Deal>> getDeals() async {
    try {
      final deals = await localDataSource.getDeals();
      return deals;
    } catch (e) {
      throw Exception("Repository Error: $e");
    }
  }
}