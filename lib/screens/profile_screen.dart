import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _profileController;
  late Animation<double> _profileAnimation;
  String? userEmail;
  String? userName;

  final Map<String, dynamic> userProfile = {
    'joinDate': 'January 2024',
    'coursesCompleted': 3,
    'totalCourses': 6,
    'streak': 12,
    'totalHours': 45,
  };

  @override
  void initState() {
    super.initState();
    _profileController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _profileAnimation = CurvedAnimation(
      parent: _profileController,
      curve: Curves.easeOutQuart,
    );
    _profileController.forward();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final email = await AuthService.getCurrentUserEmail();
    setState(() {
      userEmail = email;
      userName = email != null ? AuthService.getUserDisplayName(email) : 'User';
    });
  }

  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF667eea),
              Color(0xFFF8F9FA),
            ],
            stops: [0.0, 0.4],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: AnimatedBuilder(
              animation: _profileAnimation,
              builder: (context, child) {
                return Column(
                  children: [
                    // Header Section
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Back Button
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon:
                                    Icon(Icons.arrow_back, color: Colors.white),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () => _showSettingsDialog(),
                                icon: Icon(Icons.settings, color: Colors.white),
                              ),
                            ],
                          ),

                          SizedBox(height: 20),

                          // Profile Picture
                          FadeTransition(
                            opacity: _profileAnimation,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.white, Colors.blue[50]!],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Color(0xFF667eea),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          // User Info
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(_profileAnimation),
                            child: Column(
                              children: [
                                Text(
                                  userName ?? 'User',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  userEmail ?? 'user@example.com',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Member since ${userProfile['joinDate']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Stats Section
                    Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(_profileAnimation),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Learning Stats',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildProfileStatCard(
                                    'Courses',
                                    '${userProfile['coursesCompleted']}/${userProfile['totalCourses']}',
                                    Icons.school,
                                    Colors.blue,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildProfileStatCard(
                                    'Streak',
                                    '${userProfile['streak']} days',
                                    Icons.local_fire_department,
                                    Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildProfileStatCard(
                                    'Study Time',
                                    '${userProfile['totalHours']}h',
                                    Icons.access_time,
                                    Colors.green,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: _buildProfileStatCard(
                                    'Rank',
                                    'Gold',
                                    Icons.emoji_events,
                                    Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Achievement Section
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(_profileAnimation),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Achievements',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 20),
                            _buildAchievementItem(
                              'First Course Completed',
                              'Completed your first learning journey',
                              Icons.emoji_events,
                              Colors.yellow,
                            ),
                            _buildAchievementItem(
                              '7 Day Streak',
                              'Studied for 7 consecutive days',
                              Icons.local_fire_department,
                              Colors.orange,
                            ),
                            _buildAchievementItem(
                              'Quiz Master',
                              'Scored 100% on World Geography Quiz',
                              Icons.quiz,
                              Colors.blue,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 40),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(
      String title, String description, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.settings, color: Color(0xFF667eea)),
              SizedBox(width: 12),
              Text(
                'Settings',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications', style: GoogleFonts.poppins()),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.privacy_tip),
                title: Text('Privacy', style: GoogleFonts.poppins()),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text('Help & Support', style: GoogleFonts.poppins()),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text(
                  'Logout',
                  style: GoogleFonts.poppins(color: Colors.red),
                ),
                onTap: () async {
                  await AuthService.signOut();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
