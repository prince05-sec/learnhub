import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/course.dart';
import '../widgets/course_card.dart';
import '../services/auth_service.dart';
import 'course_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _staggerController;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  String? userName;

  final List<Course> courses = [
    Course(
      id: 0,
      title: 'Introduction to Algebra',
      description: 'Learn the basics of algebraic expressions and equations.',
      category: 'Mathematics',
      color: Colors.purple,
      icon: Icons.calculate,
      lessons: 12,
      progress: 0.3,
    ),
    Course(
      id: 1,
      title: 'History of Ancient Egypt',
      description:
          'Explore the wonders of pyramids, pharaohs, and hieroglyphs.',
      category: 'History',
      color: Colors.orange,
      icon: Icons.architecture,
      lessons: 8,
      progress: 0.0,
    ),
    Course(
      id: 2,
      title: 'Human Anatomy Overview',
      description: 'Understand the structure and function of the human body.',
      category: 'Biology',
      color: Colors.red,
      icon: Icons.favorite,
      lessons: 15,
      progress: 0.6,
    ),
    Course(
      id: 3,
      title: 'World Geography Quiz',
      description: 'Test your knowledge of world maps and capitals.',
      category: 'Geography',
      color: Colors.green,
      icon: Icons.public,
      lessons: 6,
      progress: 1.0,
      difficulty: 'Intermediate',
    ),
    Course(
      id: 4,
      title: 'Coding for Beginners',
      description: 'Learn the foundations of programming in Python.',
      category: 'Programming',
      color: Colors.blue,
      icon: Icons.code,
      lessons: 20,
      progress: 0.4,
    ),
    Course(
      id: 5,
      title: 'Environmental Science Basics',
      description: 'Discover how ecosystems function and why they matter.',
      category: 'Science',
      color: Colors.teal,
      icon: Icons.eco,
      lessons: 10,
      progress: 0.2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    _staggerController.forward();

    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 50;
      });
    });

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final email = await AuthService.getCurrentUserEmail();
    setState(() {
      userName = email != null ? AuthService.getUserDisplayName(email) : 'User';
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _scrollController.dispose();
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
              Color(0xFFF8F9FA),
              Color(0xFFE9ECEF),
            ],
          ),
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 120.0,
              floating: true,
              pinned: true,
              elevation: _isScrolled ? 8 : 0,
              backgroundColor: _isScrolled ? Colors.white : Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: AnimatedOpacity(
                  opacity: _isScrolled ? 1 : 0,
                  duration: Duration(milliseconds: 200),
                  child: Text(
                    'Learning Hub',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                background: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Welcome back, ${userName ?? 'User'}! 👋',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        'Continue Learning',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.person,
                      color: _isScrolled ? Colors.black87 : Colors.grey[600]),
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                ),
              ],
            ),

            // Course Grid
            SliverPadding(
              padding: EdgeInsets.all(20),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return AnimatedBuilder(
                      animation: _staggerController,
                      builder: (context, child) {
                        final animationInterval = Interval(
                          (index / courses.length) * 0.5,
                          ((index / courses.length) * 0.5) + 0.5,
                          curve: Curves.easeOutQuart,
                        );

                        final slideAnimation = Tween<Offset>(
                          begin: Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _staggerController,
                          curve: animationInterval,
                        ));

                        final fadeAnimation = Tween<double>(
                          begin: 0.0,
                          end: 1.0,
                        ).animate(CurvedAnimation(
                          parent: _staggerController,
                          curve: animationInterval,
                        ));

                        return SlideTransition(
                          position: slideAnimation,
                          child: FadeTransition(
                            opacity: fadeAnimation,
                            child: CourseCard(
                              course: courses[index],
                              onTap: () => _navigateToCourse(courses[index]),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: courses.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCourse(Course course) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CourseDetailScreen(course: course),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOutCubic)),
            ),
            child: child,
          );
        },
        transitionDuration: Duration(milliseconds: 400),
      ),
    );
  }
}
