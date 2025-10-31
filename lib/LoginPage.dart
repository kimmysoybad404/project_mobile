import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_mobile/RegisterPage.dart';
import 'package:project_mobile/BottomBar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final int selectRole;
  const LoginPage({super.key, required this.selectRole});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  int Role = 1;
  int SelectRole = 1;
  String Name = "";
  bool hidePassword = true;
  Color DarkBrown = const Color(0xFF8B5B46);
  Color LightBrown = const Color(0xFFFEC785);
  String _currentImage = "assets/images/TigarEye.png";
  String ImageTigar = "assets/images/Tigar.png";
  String ImageTigarEye = "assets/images/TigarEye.png";

  @override
  void initState() {
    super.initState();
    SelectRole = widget.selectRole;
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _currentImage = _focusNode.hasFocus ? ImageTigar : ImageTigarEye;
    });
  }

  Future<void> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/Login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = data['user'];
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString('username', user['name']);
        await prefs.setInt('role', user['role']);
        await prefs.setString('userid', user['id'].toString());

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomBar(
              role: user['role'],
              username: user['name'],
              userid: user["id"],
              newItem: null,
            ),
          ),
        );
      } else {
        _showErrorDialog(data['Message'] ?? 'Login failed');
      }
    } catch (e) {
      _showErrorDialog("🚫 Server not responding");
      print(e);
    }
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      animType: AnimType.scale,
      title: 'Login Failed',
      titleTextStyle: const TextStyle(
        color: Color(0xFF8B5B46),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      desc: message,
      descTextStyle: const TextStyle(
        color: Color(0xFF5B4033),
        fontSize: 16,
        height: 1.4,
      ),
      dialogBackgroundColor: const Color(0xFFFFF4DA), // ครีมอ่อน
      btnOkText: "OK",
      btnOkColor: const Color(0xFF8B5B46),
      btnOkOnPress: () {},
      buttonsBorderRadius: const BorderRadius.all(Radius.circular(14)),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      dialogBorderRadius: const BorderRadius.all(Radius.circular(20)),
      headerAnimationLoop: false,
      dismissOnTouchOutside: true,
      width: 340,
      alignment: Alignment.center,
      barrierColor: Colors.black.withOpacity(0.3),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 350,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [LightBrown, LightBrown],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4A574).withOpacity(0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: DarkBrown,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          child: TextField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person, color: DarkBrown),
                              labelText: 'Username',
                              labelStyle: TextStyle(color: DarkBrown),
                              filled: true,
                              fillColor: const Color(0xFFFFFAF0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: DarkBrown,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),

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
                                onTap: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
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
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: DarkBrown,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                final username = usernameController.text.trim();
                                final password = passwordController.text.trim();

                                if (username.isEmpty || password.isEmpty) {
                                  _showErrorDialog(
                                    "⚠️ Please fill in all fields",
                                  );
                                } else {
                                  loginUser(username, password);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DarkBrown,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                "Login",
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

                        if (SelectRole == 1)
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Create an account",
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
                top: -350,
                left: 0,
                right: 0,
                child: Center(child: Image.asset(_currentImage, height: 300)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
