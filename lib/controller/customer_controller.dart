import 'package:get/get.dart';
import '../database/database_helper.dart';
import '../models/customer.dart';

class CustomerController extends GetxController {
  var customerList = <Customer>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  void fetchCustomers() async {
    final customers = await DatabaseHelper.instance.getAllCustomers();
    customerList.assignAll(customers);
  }
}
