import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../services/user_service.dart';
import '../services/parking_service.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // User information (will be loaded from login/session)
  String userPhoneNumber = "";
  String userName = "";
  String userId = "";
  
  // Flag to prevent multiple data loading
  bool _hasLoadedData = false;
  
  // Dropdown variables
  String? selectedParkingLot;
  
  // Parsed parking information from selected dropdown item
  String currentParkingName = "";
  String currentParkingAddress = "";
  String currentParkingId = "";  // Will be set to parking name or extracted ID
  
  // Parking lots data for dropdown (empty initially)
  List<Map<String, dynamic>> parkingLots = [];

  // Detailed parking lot information (empty initially)
  Map<String, Map<String, dynamic>> parkingLotDetails = {};

  @override
  void initState() {
    super.initState();
    // No default selection since there's no data
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Only load data once to prevent resetting dropdown selection
    if (_hasLoadedData) return;
    
    // Get user data passed from login page
    final Map<String, dynamic>? args = 
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args != null) {
      setState(() {
        userId = args['userId'] ?? '';           // Phone number (from database user_id field)
        userPhoneNumber = args['userPhone'] ?? ''; // Same as userId 
        userName = args['userName'] ?? 'User';     // Default, will be loaded from database
      });
      
      print('Home page received user data: userId=$userId, phone=$userPhoneNumber, name=$userName');
      
      // Load user's actual data from database using the userId (phone number)
      if (userId.isNotEmpty) {
        _loadUserData();
        _hasLoadedData = true; // Mark as loaded to prevent reload
      }
    }
  }

  // Load user-specific data from APIs
  Future<void> _loadUserData() async {
    print('Loading user data for userId: $userId');
    
    try {
      // Get real user information from database
      final userInfo = await UserService.getUserInfo(userId);
      
      setState(() {
        // Update user name from database
        userName = userInfo['name'] ?? 'User';
        // userPhoneNumber remains the same as it's the user_id
      });
      
      print('Updated user info from API: name=$userName, userId=$userId');
      
      // Load user's registered parkings
      await _loadUserRegisteredParkings();
      
    } catch (e) {
      print('Failed to load user info: $e');
      // Handle error - maybe show a message to user
      if (e is NetworkException) {
        print('Network connection error');
      } else if (e is NotFoundException) {
        print('User information not found');
      } else {
        print('Unknown error: $e');
      }
    }
  }

  // Load user's registered parkings from API
  Future<void> _loadUserRegisteredParkings() async {
    print('Loading registered parkings for userId: $userId');
    
    try {
      // Get registered parkings list from API
      final registeredParkings = await UserService.getUserRegisters(userId);
      
      setState(() {
        // Convert to dropdown format
        parkingLots = registeredParkings.map((parkingString) => {
          'value': parkingString,
          'display': parkingString,
        }).toList();
        
        // Auto select first option ONLY if no selection has been made yet
        if (parkingLots.isNotEmpty && selectedParkingLot == null) {
          selectedParkingLot = parkingLots[0]['value'];
          _processSelectedParking(selectedParkingLot!);
          print('Auto-selected first parking: ${selectedParkingLot}');
        }
        // If user already selected something, keep their selection
        else if (selectedParkingLot != null) {
          print('Keeping user selection: ${selectedParkingLot}');
        }
      });
      
      print('Loaded ${registeredParkings.length} registered parkings');
      
    } catch (e) {
      print('Failed to load registered parkings: $e');
      
      // Set empty state for UI
      setState(() {
        parkingLots = [];
        selectedParkingLot = null;
      });
    }
  }
  
  // Build basic parking info from parsed dropdown data
  Widget _buildBasicParkingInfo() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Row 1: Parking Name (from parsed data)
          _buildInfoRow(
            icon: Icons.local_parking,
            label: 'Parking Name',
            value: currentParkingName,
            color: Colors.blue,
          ),
          SizedBox(height: 10),
          
          // Row 2: Address (from parsed data)
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'Address',
            value: currentParkingAddress,
            color: Colors.green,
          ),
          SizedBox(height: 10),
          
          // Placeholder for additional info
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.grey.shade600, size: 16),
                SizedBox(width: 8),
                Text(
                  'Loading detailed information...',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // Process selected parking string (similar to Unity ProcessAndDisplayInfo)
  void _processSelectedParking(String selectedString) {
    print('Processing selected parking: $selectedString');
    
    // Parse format: "address_parts, parking_name"
    // Example: "123 Nguyen Van A, District 1, Parking A"
    // Parking name is always after the last comma
    List<String> splitData = selectedString.split(', ');
    
    if (splitData.length >= 2) {
      // Last part is parking name (always after last comma)
      String parkingName = splitData.last.trim();
      
      // Join remaining parts as address
      String address = splitData.sublist(0, splitData.length - 1).join(', ').trim();
      
      print('Parsed - Address: $address, Parking Name: $parkingName');
      
      // Update state with parsed information immediately
      setState(() {
        currentParkingName = parkingName;
        currentParkingAddress = address;
        currentParkingId = ""; // Will be loaded from API
      });
      
      print('Updated UI - Name: $currentParkingName, Address: $currentParkingAddress');
      
      // Load real parking ID from API
      _loadParkingId(address, parkingName);
      
    } else {
      print('Invalid parking string format: $selectedString');
      
      // Set empty values for invalid format
      setState(() {
        currentParkingName = "";
        currentParkingAddress = "";
        currentParkingId = "";
      });
    }
  }
  
  // Load real parking ID from API using address and parking name
  Future<void> _loadParkingId(String address, String parkingName) async {
    print('Loading parking ID for: $address, $parkingName');
    
    try {
      final parkingId = await ParkingService.getParkingId(address, parkingName);
      
      setState(() {
        currentParkingId = parkingId;
      });
      
      print('Loaded parking ID: $currentParkingId');
      
      // Load parking slots information
      await _loadParkingSlots();
      
    } catch (e) {
      print('Failed to load parking ID: $e');
      
      // Fallback: use parking name as ID
      setState(() {
        currentParkingId = parkingName;
      });
      
      print('Using fallback parking ID: $currentParkingId');
    }
  }
  
  // Load parking slots and update UI with empty/parked/total counts
  Future<void> _loadParkingSlots() async {
    if (currentParkingId.isEmpty) return;
    
    print('Loading parking slots for parking ID: $currentParkingId');
    
    try {
      final slotsInfo = await ParkingService.getParkingSlots(currentParkingId);
      
      // Update parkingLotDetails with all parking information from API
      setState(() {
        parkingLotDetails[selectedParkingLot!] = {
          'name': currentParkingName,
          'address': currentParkingAddress, 
          'empty': slotsInfo['empty'],
          'parked': slotsInfo['parked'],
          'total': slotsInfo['total'],
          // 'location': slotsInfo['parking_id'] ?? currentParkingId, // Not needed for now
          // 'licenses': slotsInfo['licenses'] ?? [], // Not needed for now
          'temperature': 'N/A', // Will be loaded separately if needed
          'humidity': 'N/A',
          'light': 'N/A',
          'last_update': slotsInfo['last_update'] ?? '',
        };
      });
      
      print('Updated parking details - Empty: ${slotsInfo['empty']}, Parked: ${slotsInfo['parked']}, Total: ${slotsInfo['total']}');
      print('License plates: ${slotsInfo['licenses']}');
      print('Last update: ${slotsInfo['last_update']}');
      
    } catch (e) {
      print('Failed to load parking slots: $e');
      
      // Set default values on error
      setState(() {
        parkingLotDetails[selectedParkingLot!] = {
          'name': currentParkingName,
          'address': currentParkingAddress,
          'empty': 0,
          'parked': 0, 
          'total': 0,
          // 'location': currentParkingId, // Not needed for now
          // 'licenses': [], // Not needed for now
          'temperature': 'N/A',
          'humidity': 'N/A',
          'light': 'N/A',
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        children: [
          _welcomeSection(),
          SizedBox(height: 20,),
          _dropdownSection(),
          SizedBox(height: 10,), // Reduced spacing between dropdown and information
          _informationSection(),
          SizedBox(height: 16,),
          _qrButtonSection(),
          SizedBox(height: 20,),
        ],
      ),
    );
  }

  Container _welcomeSection() {
    return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo.shade600, Colors.blue.shade500],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.withValues(alpha: 0.3),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      userName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                        'Have a great day!',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  // welcome back icon 

                  Icons.emoji_emotions,
                  color: const Color.fromARGB(255, 235, 255, 161),
                  size: 32,
                ),
              ),
            ],
          ),
        );
  }

  Container _dropdownSection() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Color(0xff1D1617).withValues(alpha: 0.11),
            spreadRadius: 0,
            blurRadius: 40,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: parkingLots.isEmpty 
              ? Container(
                  height: 48,
                  child: Center(
                    child: Text(
                      'No registered parkings found',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              : DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedParkingLot,
                    isExpanded: true,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey.shade600,
                    ),
                    items: parkingLots.map((Map<String, dynamic> lot) {
                      return DropdownMenuItem<String>(
                        value: lot['value'],
                        child: Text(
                          lot['display'],
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      print('Dropdown onChanged called with: $newValue');
                      setState(() {
                        selectedParkingLot = newValue;
                        if (newValue != null) {
                          _processSelectedParking(newValue);
                        }
                      });
                      print('Updated selectedParkingLot to: $selectedParkingLot');
                      if (newValue != null) {
                        _showCategoryInfo(newValue);
                      }
                    },
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _informationSection() {
    if (selectedParkingLot == null || parkingLots.isEmpty) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            'Please select a parking lot',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    // Check if we have detailed info from API, otherwise show basic parsed info
    Map<String, dynamic>? currentInfo = parkingLotDetails[selectedParkingLot];
    
    if (currentInfo == null) {
      // Show basic info from parsed dropdown data
      if (currentParkingName.isNotEmpty && currentParkingAddress.isNotEmpty) {
        return Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicParkingInfo(),
            ],
          ),
        );
      } else {
        // Still loading or no selection
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              'Loading parking information...',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
        );
      }
    }

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 0), // Reduced top margin
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildParkingInfoCard(currentInfo),
        ],
      ),
    );
  }

  Widget _buildParkingInfoCard(Map<String, dynamic> info) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Row 1: Name
          _buildInfoRow(
            icon: Icons.title,
            label: 'Name',
            value: info['name'],
            color: Colors.blue,
          ),
          SizedBox(height: 10),
          
          // Row 2: Address
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'Address',
            value: info['address'],
            color: Colors.green,
          ),
          SizedBox(height: 10),

          // Row 3: Empty - Parked - Total
          _buildParkingStatusRow(
            empty: info['empty'],
            parked: info['parked'],
            total: info['total'],
          ),
          SizedBox(height: 10),
          
          // Row 4: License Plates - COMMENTED (not needed for now)
          // _buildLicensesRow(info['licenses']),
          // SizedBox(height: 10),

          // Row 5: Location/Lot - COMMENTED (not needed for now) 
          // _buildInfoRow(
          //   icon: Icons.gps_fixed,
          //   label: 'Lot',
          //   value: info['location'],
          //   color: Colors.purple,
          // ),
          // SizedBox(height: 10),
          
          // Row 6: Environment Information
          _buildEnvironmentRow(
            temperature: info['temperature'],
            humidity: info['humidity'],
            light: info['light'],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
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
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildParkingStatusRow({
    required int empty,
    required int parked,
    required int total,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.local_parking, size: 16, color: Colors.orange),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Parking Status',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  _buildStatusChip('Empty', empty, Colors.green),
                  SizedBox(width: 8),
                  _buildStatusChip('Parked', parked, Colors.red),
                  SizedBox(width: 8),
                  _buildStatusChip('Total', total, Colors.blue),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        '$label: $count',
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Widget _buildLicensesRow(List<dynamic> licenses) - COMMENTED (not needed for now)
  // {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Container(
  //         padding: EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: Colors.indigo.withValues(alpha: 0.1),
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: Icon(Icons.confirmation_number, size: 16, color: Colors.indigo),
  //       ),
  //       SizedBox(width: 12),
  //       Expanded(
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(
  //               'License Plates',
  //               style: TextStyle(
  //                 fontSize: 12,
  //                 color: Colors.grey.shade600,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //             SizedBox(height: 4),
  //             licenses.isEmpty
  //                 ? Text(
  //                     'No vehicles parked',
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: Colors.grey.shade500,
  //                       fontStyle: FontStyle.italic,
  //                     ),
  //                   )
  //                 : Wrap(
  //                     spacing: 6,
  //                     runSpacing: 4,
  //                     children: licenses.map((license) => Container(
  //                       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  //                       decoration: BoxDecoration(
  //                         color: Colors.grey.shade100,
  //                         borderRadius: BorderRadius.circular(8),
  //                         border: Border.all(color: Colors.grey.shade300),
  //                       ),
  //                       child: Text(
  //                         license.toString(),
  //                         style: TextStyle(
  //                           fontSize: 12,
  //                           color: Colors.black87,
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     )).toList(),
  //                   ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildEnvironmentRow({
    required String temperature,
    required String humidity,
    required String light,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.teal.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.thermostat, size: 16, color: Colors.teal),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Environment',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  _buildEnvChip('🌡️ $temperature', Colors.red),
                  SizedBox(width: 8),
                  _buildEnvChip('💧 $humidity', Colors.blue),
                  SizedBox(width: 8),
                  _buildEnvChip('💡 $light', Colors.amber),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnvChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color.withValues(alpha: 0.8),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _saveQRCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('QR code saved to gallery!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _qrButtonSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton.icon(
        onPressed: () {
          _showQRCodePopup();
        },
        icon: Icon(Icons.qr_code, size: 24),
        label: Text(
          'Show my QR Code',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo.shade600,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: Colors.indigo.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  void _showQRCodePopup() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My QR Code',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.grey.shade600),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        shape: CircleBorder(),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 20),
                
                // User Info Display
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade50, Colors.blue.shade50],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.indigo.shade200),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.indigo.shade600,
                        child: Icon(Icons.person, color: Colors.white, size: 25),
                      ),
                      SizedBox(height: 12),
                      Text(
                        userName.isNotEmpty ? userName : 'User',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo.shade700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.indigo.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone, color: Colors.indigo.shade600, size: 16),
                            SizedBox(width: 6),
                            Text(
                              userPhoneNumber.isNotEmpty ? userPhoneNumber : 'No phone number',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.indigo.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 20),
                
                // QR Code
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: userPhoneNumber.isNotEmpty ? userPhoneNumber : 'No user data',
                    version: QrVersions.auto,
                    size: 180.0,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    gapless: false,
                    errorStateBuilder: (cxt, err) {
                      return Container(
                        width: 180,
                        height: 180,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.error_outline, size: 40, color: Colors.red),
                              SizedBox(height: 12),
                              Text(
                                "QR Code Error",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                SizedBox(height: 20),
                
                // Instructions
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.amber.shade700, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Show this QR code for quick identification',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade800,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 16),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _saveQRCode();
                        },
                        icon: Icon(Icons.download, size: 18),
                        label: Text('Save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCategoryInfo(String lotId) {
    // This method handles what happens when a parking lot is selected
    // Will be implemented when connecting to real data
  }

  AppBar _appBar() {
    return AppBar(
        title: const Text(
        'Trang chủ',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        GestureDetector( // right icon
          onTap: () {
            // Handle search icon tap
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: 37,
            decoration: BoxDecoration( // right icon container
              color: Color(0xffF7F8F8),
              borderRadius: BorderRadius.circular(10)
            ),
            child: SvgPicture.asset(
              'assets/icons/dot-solid-dot-stroke-svgrepo-com.svg',
              width: 24,
              height: 24,
            ),
          ),
        )
      ],
    );
  }
}