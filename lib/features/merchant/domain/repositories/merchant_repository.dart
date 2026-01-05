import '../entities/merchant_model.dart';

abstract class MerchantRepository {
  Future<MerchantModel?> fetchMerchant(String merchantId);
  Future<void> saveMerchant(MerchantModel merchant);
}
