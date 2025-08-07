import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/auth_flow_manager.dart';
import '../widgets/animated_message_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasShownWelcome = false;

  @override
  void initState() {
    super.initState();
    // Show welcome message after a short delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && !_hasShownWelcome) {
          _showWelcomeMessage();
        }
      });
    });
  }

  void _showWelcomeMessage() {
    setState(() {
      _hasShownWelcome = true;
    });
    
    MessageHelper.showAnimatedMessage(
      context,
      message: 'Welcome to ShopRadar! You are now in the main interface.',
      type: MessageType.success,
      title: 'Welcome to ShopRadar!',
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2979FF),
        elevation: 0,
        title: const Text(
          'ShopRadar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.science, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pushNamed('/test');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await AuthFlowManager.handleLogout(context: context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: isSmallScreen ? 20 : 40),
                
                // Welcome Section
                Text(
                  'Welcome to ShopRadar!',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                Text(
                  'Your account has been verified and you are now logged in successfully.',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 24 : 40),
                
                // User Info Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF2979FF)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Information',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2979FF),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),
                      FutureBuilder(
                        future: AuthService.getUser(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            final user = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Email: ${user.email}',
                                  style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      'Email Verified: ',
                                      style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                                    ),
                                    Icon(
                                      user.isEmailVerified 
                                          ? Icons.check_circle 
                                          : Icons.cancel,
                                      color: user.isEmailVerified 
                                          ? Colors.green 
                                          : Colors.red,
                                      size: isSmallScreen ? 18 : 20,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Text(
                              'Loading user information...',
                              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 24 : 40),
                
                // Main Welcome Banner
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2979FF), Color(0xFF2DD4BF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to ShopRadar!',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 20 : 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your smart shopping companion',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: isSmallScreen ? 16 : 24),
                
                // Quick Actions Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: isSmallScreen ? 12 : 16,
                  mainAxisSpacing: isSmallScreen ? 12 : 16,
                  childAspectRatio: isSmallScreen ? 1.1 : 1.2,
                  children: [
                    _buildActionCard(
                      icon: Icons.store,
                      title: 'Find Stores',
                      subtitle: 'Discover nearby shops',
                      color: Colors.blue,
                      isSmallScreen: isSmallScreen,
                    ),
                    _buildActionCard(
                      icon: Icons.local_offer,
                      title: 'Deals & Offers',
                      subtitle: 'Best prices around',
                      color: Colors.orange,
                      isSmallScreen: isSmallScreen,
                    ),
                    _buildActionCard(
                      icon: Icons.shopping_cart,
                      title: 'Shopping List',
                      subtitle: 'Organize your needs',
                      color: Colors.green,
                      isSmallScreen: isSmallScreen,
                    ),
                    _buildActionCard(
                      icon: Icons.analytics,
                      title: 'Price History',
                      subtitle: 'Track price changes',
                      color: Colors.purple,
                      isSmallScreen: isSmallScreen,
                    ),
                  ],
                ),
                
                SizedBox(height: isSmallScreen ? 16 : 24),
                
                // Recent Activity
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recent Activity',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 8 : 12),
                      _buildActivityItem(
                        icon: Icons.check_circle,
                        title: 'Email verified successfully',
                        subtitle: 'Your account is now active',
                        color: Colors.green,
                        isSmallScreen: isSmallScreen,
                      ),
                      SizedBox(height: isSmallScreen ? 6 : 8),
                      _buildActivityItem(
                        icon: Icons.login,
                        title: 'Logged in successfully',
                        subtitle: 'Welcome back to ShopRadar',
                        color: Colors.blue,
                        isSmallScreen: isSmallScreen,
                      ),
                    ],
                  ),
                ),
                
                // Bottom padding to ensure content doesn't get cut off
                SizedBox(height: isSmallScreen ? 20 : 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: isSmallScreen ? 28 : 32,
            color: color,
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            title,
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 2 : 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isSmallScreen ? 10 : 12,
              color: color.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required bool isSmallScreen,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: isSmallScreen ? 18 : 20,
            color: color,
          ),
        ),
        SizedBox(width: isSmallScreen ? 8 : 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isSmallScreen ? 10 : 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 