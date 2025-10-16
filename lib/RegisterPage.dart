import 'package:flutter/material.dart';
import 'package:project_mobile/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      bottomNavigationBar: Register(),
    );
  }
}

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 420,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Color(0xFFF8F9FF)],
          ),
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6366F1).withOpacity(0.3),
              blurRadius: 30,
              offset: Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),

            SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Color(0xFF6366F1)),
                  labelText: 'Full Name',
                  labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person, color: Color(0xFF6366F1)),
                  labelText: 'Username',
                  labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: TextField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock, color: Color(0xFF6366F1)),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    child: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color(0xFF9CA3AF)),
                  filled: true,
                  fillColor: Color(0xFFF3F4F6),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE5E7EB),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF6366F1), width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6366F1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    shadowColor: Color(0xFF6366F1).withOpacity(0.4),
                  ),
                  child: Text(
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

            SizedBox(height: 10),

            TextButton(
              style: TextButton.styleFrom(overlayColor: Colors.transparent),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: Text(
                "Already have an account?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
