import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dropdown variables
  String? selectedParkingLot;
  
  // Parking lots data for dropdown
  List<Map<String, dynamic>> parkingLots = [
    {
      'id': 'lot1',
      'displayName': 'Downtown Plaza Zone A - 123 Main Street, Downtown',
      'name': 'Downtown Plaza Zone A',
      'address': '123 Main Street, Downtown',
    },
    {
      'id': 'lot2', 
      'displayName': 'Shopping Mall Zone B - 456 Commerce Ave, Mall District',
      'name': 'Shopping Mall Zone B',
      'address': '456 Commerce Ave, Mall District',
    },
    {
      'id': 'lot3',
      'displayName': 'Airport Terminal Zone C - 789 Airport Blvd, Terminal 1',
      'name': 'Airport Terminal Zone C', 
      'address': '789 Airport Blvd, Terminal 1',
    },
    {
      'id': 'lot4',
      'displayName': 'Premium Spot A-12 - 1st Floor, Section A, Row 12',
      'name': 'Premium Spot A-12',
      'address': '1st Floor, Section A, Row 12',
    },
    {
      'id': 'lot5',
      'displayName': 'VIP Executive Area - Ground Floor, VIP Section',
      'name': 'VIP Executive Area',
      'address': 'Ground Floor, VIP Section',
    },
  ];

  // Detailed parking lot information
  Map<String, Map<String, dynamic>> parkingLotDetails = {
    'lot1': {
      'name': 'Downtown Plaza Zone A',
      'address': '123 Main Street, Downtown',
      'empty': 15,
      'parked': 35,
      'total': 50,
      'licenses': ['ABC-123', 'XYZ-789', 'LMN-456', 'DEF-321'],
      'location': 'GPS: 40.7128, -74.0060',
      'temperature': '22°C',
      'humidity': '65%',
      'light': 'Bright'
    },
    'lot2': {
      'name': 'Shopping Mall Zone B',
      'address': '456 Commerce Ave, Mall District',
      'empty': 8,
      'parked': 22,
      'total': 30,
      'licenses': ['GHI-987', 'JKL-654', 'MNO-321'],
      'location': 'GPS: 40.7589, -73.9851',
      'temperature': '24°C',
      'humidity': '58%',
      'light': 'Medium'
    },
    'lot3': {
      'name': 'Airport Terminal Zone C',
      'address': '789 Airport Blvd, Terminal 1',
      'empty': 22,
      'parked': 18,
      'total': 40,
      'licenses': ['PQR-159', 'STU-753', 'VWX-951', 'YZA-357', 'BCD-852'],
      'location': 'GPS: 40.6892, -74.1745',
      'temperature': '20°C',
      'humidity': '70%',
      'light': 'Dim'
    },
    'lot4': {
      'name': 'Premium Spot A-12',
      'address': '1st Floor, Section A, Row 12',
      'empty': 1,
      'parked': 0,
      'total': 1,
      'licenses': <String>[],
      'location': 'GPS: 40.7128, -74.0062',
      'temperature': '23°C',
      'humidity': '60%',
      'light': 'Bright'
    },
    'lot5': {
      'name': 'VIP Executive Area',
      'address': 'Ground Floor, VIP Section',
      'empty': 3,
      'parked': 7,
      'total': 10,
      'licenses': ['VIP-001', 'VIP-002', 'VIP-003'],
      'location': 'GPS: 40.7125, -74.0058',
      'temperature': '25°C',
      'humidity': '55%',
      'light': 'Bright'
    },
  };

  @override
  void initState() {
    super.initState();
    // Set the first parking lot as default selection
    selectedParkingLot = parkingLots.first['id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        children: [
          _dropdownSection(),
          SizedBox(height: 10,), // Reduced spacing between dropdown and information
          _informationSection(),
          SizedBox(height: 20,),
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
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedParkingLot,
                isExpanded: true,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey.shade600,
                ),
                items: parkingLots.map((Map<String, dynamic> lot) {
                  return DropdownMenuItem<String>(
                    value: lot['id'],
                    child: Text(
                      lot['displayName'],
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedParkingLot = newValue;
                  });
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
    Map<String, dynamic>? currentInfo = parkingLotDetails[selectedParkingLot];
    
    if (currentInfo == null) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
      );
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
          
          // Row 4: License Plates
          _buildLicensesRow(info['licenses']),
          SizedBox(height: 10),

          // Row 5: Location
          _buildInfoRow(
            icon: Icons.gps_fixed,
            label: 'Lot',
            value: info['location'],
            color: Colors.purple,
          ),
          SizedBox(height: 10),
          
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

  Widget _buildLicensesRow(List<dynamic> licenses) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.indigo.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.confirmation_number, size: 16, color: Colors.indigo),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'License Plates',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4),
              licenses.isEmpty
                  ? Text(
                      'No vehicles parked',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  : Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: licenses.map((license) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Text(
                          license.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )).toList(),
                    ),
            ],
          ),
        ),
      ],
    );
  }

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

  void _showCategoryInfo(String lotId) {
    // This method handles what happens when a parking lot is selected
    final lot = parkingLots.firstWhere((lot) => lot['id'] == lotId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: ${lot['name']}'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
        title: const Text(
        'Home',
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