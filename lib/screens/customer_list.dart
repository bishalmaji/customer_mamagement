import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/customer_controller.dart';
import '../controller/user_controller.dart';
import 'add_customer.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerListPage extends StatelessWidget {
  final CustomerController customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer List'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout'),
              ),
            ],
            onSelected: (value) async {
              if (value == 'logout') {
                Get.find<UserController>().logout();

              }
            },
          ),
        ],
      ),
      body: Obx(() {
        if (customerController.customerList.isEmpty) {
          return const Center(child: Text("No Customer Data Found"));
        } else {
          return ListView.builder(
            itemCount: customerController.customerList.length,
            itemBuilder: (context, index) {
              final customer = customerController.customerList[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (customer.image != null)
                        Image.file(
                          File(customer.image!),
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      Text('Name: ${customer.name}', style: TextStyle(fontSize: 18)),
                      Text('Email: ${customer.email}', style: TextStyle(fontSize: 16)),
                      Text('Mobile: ${customer.mobile}', style: TextStyle(fontSize: 16)),
                      if (customer.address != null)
                        Text('Address: ${customer.address}', style: TextStyle(fontSize: 16)),
                      IconButton(
                        icon:
                        Icon(Icons.map),
                        onPressed: () async {
                          if (customer.latitude != null && customer.longitude != null) {
                            final url = 'https://www.google.com/maps/search/?api=1&query=${customer.latitude},${customer.longitude}';
                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              throw 'Could not launch $url';
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(AddCustomerPage());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
