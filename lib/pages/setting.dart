import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_session.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // User data will be loaded from UserSession
  Map<String, dynamic>? userData;
  List<Map<String, dynamic>> registeredVehicles = [];
  List<Map<String, dynamic>> parkingHistory = [];
  
  bool notificationsEnabled = true;
  bool locationEnabled = true;
  String selectedLanguage = 'English';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    try {
      final userSession = Provider.of<UserSession>(context, listen: false);
      
      if (userSession.isValidSession()) {
        userData = userSession.getUserData();
        
        // Load user vehicles and parking history here
        // For now, we'll leave them empty until we implement the APIs
        await _loadVehicles();
        await _loadParkingHistory();
      }
      
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _loadVehicles() async {
    registeredVehicles = [];
  }

  Future<void> _loadParkingHistory() async {
    parkingHistory = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.all(16),
              children: [
                _userInfoSection(),
                SizedBox(height: 24),
                _registeredVehiclesSection(),
                SizedBox(height: 24),
                _parkingHistorySection(),
                SizedBox(height: 24),
                _appSettingsSection(),
                SizedBox(height: 24),
                _accountActionsSection(),
                SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _userInfoSection() {
    return Consumer<UserSession>(
      builder: (context, userSession, child) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color(0xff1D1617).withValues(alpha: 0.08),
                spreadRadius: 0,
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.person, color: Colors.blue.shade600, size: 24),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Manage your personal details',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue.shade600),
                    onPressed: () {
                      _showEditProfileDialog();
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              SizedBox(height: 16),
              if (userSession.isLoading)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else ...[
                _buildInfoRow(
                  Icons.person_outline, 
                  'Full Name', 
                  userSession.userName.isNotEmpty ? userSession.userName : 'Not available'
                ),
                SizedBox(height: 12),
                _buildInfoRow(
                  Icons.phone_outlined, 
                  'Phone Number', 
                  userSession.userPhone.isNotEmpty ? userSession.userPhone : 'Not available'
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _registeredVehiclesSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1D1617).withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.directions_car, color: Colors.green.shade600, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Registered Vehicles',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      registeredVehicles.isEmpty 
                          ? 'No vehicles registered' 
                          : '${registeredVehicles.length} vehicles registered',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (registeredVehicles.isEmpty)
            _buildEmptyVehiclesState()
          else
            ...registeredVehicles.map((vehicle) => _buildVehicleCard(vehicle)),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: vehicle['isPrimary'] ? Colors.blue.shade50 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: vehicle['isPrimary'] ? Colors.blue.shade200 : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: vehicle['isPrimary'] ? Colors.blue.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.car_rental,
              color: vehicle['isPrimary'] ? Colors.blue.shade600 : Colors.grey.shade600,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      vehicle['licensePlate'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (vehicle['isPrimary']) ...[
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'PRIMARY',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  '${vehicle['year']} ${vehicle['make']} ${vehicle['model']}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                Text(
                  'Color: ${vehicle['color']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
            onPressed: () {
              _showVehicleOptionsDialog(vehicle);
            },
          ),
        ],
      ),
    );
  }

  Widget _parkingHistorySection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1D1617).withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.history, color: Colors.orange.shade600, size: 24),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Parking History',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Recent parking sessions',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  _showFullHistoryDialog();
                },
                child: Text('View All'),
              ),
            ],
          ),
          SizedBox(height: 16),
          if (parkingHistory.isEmpty)
            _buildEmptyHistoryState()
          else
            ...parkingHistory.take(3).map((history) => _buildHistoryCard(history)),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> history) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                history['date'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  history['status'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            history['location'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${history['timeIn']} - ${history['timeOut']}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                '${history['duration']} • ${history['cost']}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _appSettingsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1D1617).withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.settings, color: Colors.purple.shade600, size: 24),
              ),
              SizedBox(width: 16),
              Text(
                'App Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildSettingRow(
            Icons.notifications_outlined,
            'Notifications',
            'Receive parking alerts',
            Switch(
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
          ),
          _buildSettingRow(
            Icons.location_on_outlined,
            'Location Services',
            'Auto-detect parking zones',
            Switch(
              value: locationEnabled,
              onChanged: (value) {
                setState(() {
                  locationEnabled = value;
                });
              },
            ),
          ),
          _buildSettingRow(
            Icons.language_outlined,
            'Language',
            selectedLanguage,
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
            onTap: () {
              _showLanguageDialog();
            },
          ),
          _buildSettingRow(
            Icons.security_outlined,
            'Privacy & Security',
            'Manage your data',
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          _buildSettingRow(
            Icons.help_outline,
            'Help & Support',
            'Get assistance',
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
            onTap: () {
              // Navigate to help
            },
          ),
        ],
      ),
    );
  }

  Widget _accountActionsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1D1617).withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.account_circle_outlined, color: Colors.red.shade600, size: 24),
              ),
              SizedBox(width: 16),
              Text(
                'Account Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildSettingRow(
            Icons.logout_outlined,
            'Sign Out',
            'Sign out of your account',
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
            onTap: () {
              _showSignOutDialog();
            },
          ),
          _buildSettingRow(
            Icons.delete_outline,
            'Delete Account',
            'Permanently delete your account',
            Icon(Icons.chevron_right, color: Colors.red.shade400),
            textColor: Colors.red.shade600,
            onTap: () {
              _showDeleteAccountDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingRow(
    IconData icon,
    String title,
    String subtitle,
    Widget trailing, {
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: textColor ?? Colors.grey.shade600),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: textColor ?? Colors.black87,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyVehiclesState() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.directions_car_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 12),
          Text(
            'No Vehicles Registered',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Add your vehicle information to get started',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              
              _showAddVehicleDialog();
            },
            icon: Icon(Icons.add),
            label: Text('Add Vehicle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistoryState() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.history,
            size: 48,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 12),
          Text(
            'No Parking History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Your parking sessions will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Dialog methods
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Text('Profile editing feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAddVehicleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Vehicle'),
        content: Text('Add vehicle feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showVehicleOptionsDialog(Map<String, dynamic> vehicle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Vehicle Options'),
        content: Text('Options for ${vehicle['licensePlate']}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFullHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Full History'),
        content: Text('Full parking history coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('English'),
              onTap: () {
                setState(() {
                  selectedLanguage = 'English';
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Tiếng Việt'),
              onTap: () {
                setState(() {
                  selectedLanguage = 'Tiếng Việt';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sign Out'),
        content: Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              
              // Clear user session
              final userSession = Provider.of<UserSession>(context, listen: false);
              userSession.clearSession();
              
              // Navigate to login page
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('This action cannot be undone. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement delete account logic
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        'Settings',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }
}
