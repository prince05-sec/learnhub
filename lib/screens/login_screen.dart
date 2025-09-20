import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;
  bool _isLoading = false;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.elasticOut));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _animationController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleDemoSignIn() async {
    setState(() => _isLoading = true);

    try {
      final success = await AuthService.signInWithDemo();
      if (success) {
        HapticFeedback.mediumImpact();
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showSnackBar('Demo sign-in failed. Please try again.');
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleEmailSignIn() async {
    if (_emailController.text.isEmpty) {
      _showSnackBar('Please enter your email');
      return;
    }

    if (_passwordController.text.isEmpty) {
      _showSnackBar('Please enter your password');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success = await AuthService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        HapticFeedback.mediumImpact();
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showSnackBar(
            'Invalid email or password. Try demo@learnhub.com / demo123');
      }
    } catch (e) {
      _showSnackBar('An error occurred. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Animated Logo
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      gradient: RadialGradient(
                                        colors: [
                                          Colors.white,
                                          Colors.blue[100]!
                                        ],
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.3),
                                          blurRadius: 20,
                                          spreadRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.school_rounded,
                                      size: 60,
                                      color: Color(0xFF667eea),
                                    ),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 24),
                            Text(
                              'LearnHub',
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Learn • Code • Grow Together',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Login Form
                      Expanded(
                        flex: 3,
                        child: Container(
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome Back!',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                SizedBox(height: 40),

                                // Email TextField
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(15),
                                    border:
                                        Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: TextField(
                                    controller: _emailController,
                                    decoration: InputDecoration(
                                      hintText: 'demo@learnhub.com',
                                      prefixIcon: Icon(Icons.email_outlined,
                                          color: Colors.grey[600]),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 16),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                ),

                                SizedBox(height: 16),

                                // Password TextField
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(15),
                                    border:
                                        Border.all(color: Colors.grey[200]!),
                                  ),
                                  child: TextField(
                                    controller: _passwordController,
                                    obscureText: !_showPassword,
                                    decoration: InputDecoration(
                                      hintText: 'demo123',
                                      prefixIcon: Icon(Icons.lock_outline,
                                          color: Colors.grey[600]),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _showPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: Colors.grey[600],
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _showPassword = !_showPassword;
                                          });
                                        },
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 16),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                // Email Sign In Button
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed:
                                        _isLoading ? null : _handleEmailSignIn,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF667eea),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      elevation: 3,
                                    ),
                                    child: _isLoading
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Text(
                                            'Sign In with Email',
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),

                                SizedBox(height: 20),

                                Row(
                                  children: [
                                    Expanded(
                                        child:
                                            Divider(color: Colors.grey[300])),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        'OR',
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey[600],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child:
                                            Divider(color: Colors.grey[300])),
                                  ],
                                ),

                                SizedBox(height: 20),

                                // Demo Sign In Button
                                Container(
                                  width: double.infinity,
                                  height: 56,
                                  child: OutlinedButton(
                                    onPressed:
                                        _isLoading ? null : _handleDemoSignIn,
                                    style: OutlinedButton.styleFrom(
                                      side:
                                          BorderSide(color: Colors.grey[300]!),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.play_circle_outline,
                                          color: Colors.grey[700],
                                          size: 24,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          'Quick Demo Login',
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: 16),

                                // Demo credentials info
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Colors.blue[200]!),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Demo Credentials:',
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[800],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Email: demo@learnhub.com\nPassword: demo123',
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
