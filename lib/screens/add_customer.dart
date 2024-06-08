import 'dart:async';

import 'package:customer_managment/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/custom_button.dart';
import '../components/custom_text.dart';
import '../controller/customer_controller.dart';
import '../database/database_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../models/customer.dart';
import '../utility/message_helper.dart';

class AddCustomerPage extends StatefulWidget {
  @override
  _AddCustomerPageState createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  String? _address;
  File? _image;
  double? _latitude;
  double? _longitude;
  bool _isFetchingAddress = false;
  final CustomerController customerController = Get.find();
  String _loadingText = 'getting location';
  Timer? _loadingTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Customer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [

              GestureDetector(
                onTap: () async {
                  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                  setState(() {
                    if (pickedFile != null) {
                      _image = File(pickedFile.path);
                    }
                  });
                },
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _image!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 50,
                        ),
                ),
              ),
              const SizedBox(height: 20),
              const CustomText(
                text: 'Full Name',
                textSize: 20,
                textColor: Colors.grey,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const CustomText(
                text: 'Email Id',
                textSize: 20,
                textColor: Colors.grey,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const CustomText(
                text: 'Mobile No',
                textSize: 20,
                textColor: Colors.grey,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: GestureDetector(
                  onTap: _isFetchingAddress ? null : _fetchAddress,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    color: _isFetchingAddress ? AppColors.lightGray : Colors.grey[300],
                    child: Text(
                      _isFetchingAddress ? _loadingText : (_address ?? 'Get Current Location'),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: Colors.white,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: CustomButton(
                        text: 'Add Customer',
                        onPressed: () async {
                          _validateAndAddCustomer();
                        },
                        width: 250,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegExp.hasMatch(email);
  }
  Future<void> _validateAndAddCustomer() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String mobile = _mobileController.text;
    String? address = _address;
    String? image = _image?.path;

    if (_image == null) {
      MessageHelper.showMessage(context, 'Please select image');
      return;
    }
    if (name.isEmpty) {
      MessageHelper.showMessage(context, 'Please enter the name');
      return;
    }
    if (email.isEmpty) {
      MessageHelper.showMessage(context, 'Please enter the email');
      return;
    }
    if (!_isValidEmail(email)) {
      MessageHelper.showMessage(context, 'Please enter a valid email');
      return;
    }
    if (mobile.isEmpty) {
      MessageHelper.showMessage(context, 'Please enter the mobile number');
      return;
    }
    if (address == null) {
      MessageHelper.showMessage(context, 'Please get the current address');
      return;
    }

    Customer newCustomer = Customer(
      name: name,
      email: email,
      mobile: mobile,
      address: address,
      image: image,
      latitude: _latitude,
      longitude: _longitude,
    );

    await DatabaseHelper.instance.insertCustomer(newCustomer);
    customerController.fetchCustomers();
    Get.back();
  }

  void _fetchAddress() async {
    setState(() {
      _isFetchingAddress = true;
      _loadingText = 'getting location';
      _startLoadingAnimation();
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      }

      Position position = await _determinePosition();
      _latitude = position.latitude;
      _longitude = position.longitude;
      List<Placemark> placemarks = await placemarkFromCoordinates(_latitude!, _longitude!);
      Placemark place = placemarks[0];
      setState(() {
        _address = '${place.locality}, ${place.postalCode}, ${place.country}';
        _isFetchingAddress = false;
      });
    } catch (error) {
      setState(() {
        _isFetchingAddress = false;
        _loadingTimer?.cancel();
      });
      _showErrorDialog(error.toString());
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  //get address from the location cordinates
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // for animation of text(get current location)
  // dot is added each second
  void _startLoadingAnimation() {
    const int dotCount = 3;
    int currentDotCount = 0;
    _loadingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      currentDotCount = (currentDotCount + 1) % (dotCount + 1);
      setState(() {
        _loadingText = 'getting location${'.' * currentDotCount}';
      });
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }
}
