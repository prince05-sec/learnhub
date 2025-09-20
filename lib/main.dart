import 'package:flutter/material.dart';
import 'package:learnhub/screens/home_screen.dart';
import 'package:learnhub/screens/login_screen.dart';
import 'package:learnhub/screens/profile_screen.dart';
import 'package:learnhub/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(LearnHubApp());
}

class LearnHubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      home: AuthWrapper(),
      routes: {
        '/home': (context) => HomeScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isLoading = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final isLoggedIn = await AuthService.isLoggedIn();
    setState(() {
      _isLoggedIn = isLoggedIn;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
                Color(0xFF4facfe),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_rounded,
                  size: 80,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  'LearnHub',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                CircularProgressIndicator(
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return _isLoggedIn ? HomeScreen() : LoginScreen();
  }
}
