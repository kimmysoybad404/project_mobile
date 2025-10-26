import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_mobile/LoginPage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: const Register(),
      ),
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool hidePassword = true;
  Color DarkBrown = const Color(0xFF8B5B46);
  Color LightBrown = const Color(0xFFFEC785);
  String _currentImage = "assets/images/TigarEye.png";
  String ImageTigar = "assets/images/Tigar.png";
  String ImageTigarEye = "assets/images/TigarEye.png";

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _currentImage = _focusNode.hasFocus ? ImageTigar : ImageTigarEye;
    });
  }

  Future<void> registerUser() async {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      _showErrorDialog("⚠️ Please fill in all fields");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/Register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'username': username,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showSuccessDialog(data['Message']);
      } else {
        _showErrorDialog(data['Message'] ?? 'Register failed');
      }
    } catch (e) {
      _showErrorDialog("🚫 Server not responding");
    }
  }

  void _showSuccessDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.scale,
      title: 'Register Successful 🎉',
      titleTextStyle: const TextStyle(
        color: Color(0xFF8B5B46),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      desc: message,
      descTextStyle: const TextStyle(
        color: Color(0xFF5B4033),
        fontSize: 16,
        height: 1.4,
      ),
      dialogBackgroundColor: const Color(0xFFFFF4DA),
      btnOkText: "OK",
      btnOkColor: const Color(0xFF8B5B46),
      btnOkOnPress: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage(selectRole: 1,)),
          (route) => false,
        );
      },
      buttonsBorderRadius: const BorderRadius.all(Radius.circular(14)),
      dialogBorderRadius: const BorderRadius.all(Radius.circular(20)),
      dismissOnTouchOutside: false,
      width: 340,
    ).show();
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'Register Failed',
      titleTextStyle: const TextStyle(
        color: Color(0xFF8B5B46),
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      desc: message,
      descTextStyle: const TextStyle(
        color: Color(0xFF5B4033),
        fontSize: 16,
        height: 1.4,
      ),
      dialogBackgroundColor: const Color(0xFFFFF4DA),
      btnOkText: "OK",
      btnOkColor: const Color(0xFF8B5B46),
      btnOkOnPress: () {},
      buttonsBorderRadius: const BorderRadius.all(Radius.circular(14)),
      dialogBorderRadius: const BorderRadius.all(Radius.circular(20)),
      dismissOnTouchOutside: true,
      width: 340,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 430,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [LightBrown, LightBrown]),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: DarkBrown.withOpacity(0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: DarkBrown,
                      ),
                    ),
                    const SizedBox(height: 24),
    
                    // Fullname
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_rounded,
                            color: DarkBrown,
                          ),
                          labelText: 'Fullname',
                          labelStyle: TextStyle(color: DarkBrown),
                          filled: true,
                          fillColor: const Color(0xFFFFFAF0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: DarkBrown,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
    
                    // Username
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.badge_rounded,
                            color: DarkBrown,
                          ),
                          labelText: 'Username',
                          labelStyle: TextStyle(color: DarkBrown),
                          filled: true,
                          fillColor: const Color(0xFFFFFAF0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: DarkBrown,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
    
                    // Password
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: TextField(
                        controller: passwordController,
                        focusNode: _focusNode,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: DarkBrown),
                          suffixIcon: GestureDetector(
                            onTap: () =>
                                setState(() => hidePassword = !hidePassword),
                            child: Icon(
                              hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: DarkBrown,
                            ),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: DarkBrown),
                          filled: true,
                          fillColor: const Color(0xFFFFFAF0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: DarkBrown,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),
    
                    const SizedBox(height: 16),
    
                    // Sign Up button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: registerUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: DarkBrown,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 6,
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
    
                    const SizedBox(height: 10),
    
                    // Go to login
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(selectRole: 1,),
                          ),
                        );
                      },
                      child: Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: DarkBrown,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    
          Positioned(
            top: -310,
            left: 0,
            right: 0,
            child: Center(child: Image.asset(_currentImage, height: 280)),
          ),
        ],
      ),
    );
  }
}
