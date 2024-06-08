import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/custom_button.dart';
import '../components/custom_text.dart';
import '../controller/user_controller.dart';
import '../utility/message_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _email = '';
  String _password = '';
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const CustomText(text: 'Login', textSize: 35),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.4,
                height: MediaQuery.of(context).size.width * 0.4,
                child: Image.asset('assets/login_image.png'),
              ),
              const SizedBox(height: 20),
              const CustomText(
                text: 'Enter Email',
                textSize: 20,
                textColor: Colors.grey,
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _emailController,
                  onChanged: (value) {
                    _email = value;
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const CustomText(
                text: 'Enter Password',
                textSize: 20,
                textColor: Colors.grey,
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _passwordController,
                  onChanged: (value) {
                    _password = value;
                  },
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
                      padding: EdgeInsets.all(5),
                      child: CustomButton(
                        text: 'Login',
                        onPressed: () async {
                          _validateEmailAndLogin();
                        },
                        width: 150,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _validateEmailAndLogin() async {
    if (_email.isEmpty) {
      MessageHelper.showMessage(context, 'Please enter your email');
    } else if (_password.isEmpty) {
      MessageHelper.showMessage(context, 'Please enter your password');
    } else if (_email != 'user@maxmobility.in') {
      MessageHelper.showMessage(context, 'Invalid email');
    } else if (_password != 'Abc@#123') {
      MessageHelper.showMessage(context, 'Invalid password');
    } else {

      _login();
    }
  }
  void _login() {
    final String email = _emailController.text;
    final String password = _passwordController.text;
    Get.find<UserController>().login(email, password);
  }
}

