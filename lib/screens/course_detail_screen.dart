import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/course.dart';

class CourseDetailScreen extends StatefulWidget {
  final Course course;

  const CourseDetailScreen({Key? key, required this.course}) : super(key: key);

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _heroController;
  late AnimationController _contentController;

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    _heroController.forward();
    _contentController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            backgroundColor: widget.course.color,
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedBuilder(
                animation: _heroController,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.course.color.withOpacity(0.8),
                          widget.course.color,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 60),
                          FadeTransition(
                            opacity: _heroController,
                            child: Icon(
                              widget.course.icon,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          SlideTransition(
                            position: Tween<Offset>(
                              begin: Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: _heroController,
                              curve: Curves.easeOutQuart,
                            )),
                            child: Text(
                              widget.course.title,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
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

          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _contentController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _contentController,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(
                      parent: _contentController,
                      curve: Curves.easeOutQuart,
                    )),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Course Stats
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  'Lessons',
                                  '${widget.course.lessons}',
                                  Icons.play_lesson,
                                  Colors.blue,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  'Progress',
                                  '${(widget.course.progress * 100).toInt()}%',
                                  Icons.trending_up,
                                  Colors.green,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: _buildStatCard(
                                  'Level',
                                  widget.course.difficulty,
                                  Icons.star,
                                  Colors.orange,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 30),

                          Text(
                            'About This Course',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),

                          SizedBox(height: 16),

                          Text(
                            widget.course.description,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey[600],
                              height: 1.6,
                            ),
                          ),

                          SizedBox(height: 30),

                          // Progress Section
                          if (widget.course.progress > 0) ...[
                            Text(
                              'Your Progress',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),

                            SizedBox(height: 16),

                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    widget.course.color.withOpacity(0.1),
                                    widget.course.color.withOpacity(0.05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: widget.course.color.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Course Completion',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        '${(widget.course.progress * 100).toInt()}%',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: widget.course.color,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 12),

                                  Container(
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: widget.course.progress,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              widget.course.color,
                                              widget.course.color.withOpacity(0.7),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: 30),
                          ],

                          // Action Buttons
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    HapticFeedback.mediumImpact();
                                    _showComingSoonDialog();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: widget.course.color,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        widget.course.progress > 0
                                            ? Icons.play_arrow
                                            : Icons.school,
                                        size: 20,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        widget.course.progress > 0
                                            ? 'Continue Learning'
                                            : 'Start Course',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(width: 12),

                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    _showComingSoonDialog();
                                  },
                                  icon: Icon(Icons.bookmark_border, color: Colors.grey[600]),
                                  padding: EdgeInsets.all(16),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
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
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.rocket_launch, color: widget.course.color),
              SizedBox(width: 12),
              Text(
                'Coming Soon!',
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'This feature is under development. Stay tuned for amazing learning experiences!',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Got it!',
                style: GoogleFonts.poppins(
                  color: widget.course.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}