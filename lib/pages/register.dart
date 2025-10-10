import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          SizedBox(height: 40),
          Text(
            'Monthly Parking',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 10),
          Text(
            'Please fill the input below here',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          _searchSection(),
          SizedBox(height: 40),
          _registerSection(context)
        ],
      )
    );
  }

  Container _registerSection(BuildContext context) {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Personal Information Section
          _buildSectionTitle('Personal Information', Icons.person),
          SizedBox(height: 16),
          
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Color(0xffF7F8F8),
            ),
          ),
          SizedBox(height: 16),
          
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Color(0xffF7F8F8),
            ),
          ),
          // SizedBox(height: 16),
          
          // TextField(
          //   decoration: InputDecoration(
          //     labelText: 'Email Address',
          //     prefixIcon: Icon(Icons.email_outlined),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     filled: true,
          //     fillColor: Color(0xffF7F8F8),
          //   ),
          // ),
          
          SizedBox(height: 24),
          
          // Vehicle Information Section
          _buildSectionTitle('Vehicle Information', Icons.directions_car),
          SizedBox(height: 16),
          
          TextField(
            decoration: InputDecoration(
              labelText: 'License Plate Number',
              prefixIcon: Icon(Icons.confirmation_number_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Color(0xffF7F8F8),
            ),
          ),
          SizedBox(height: 16),
          
          TextField(
            decoration: InputDecoration(
              labelText: 'Vehicle Make & Model',
              prefixIcon: Icon(Icons.car_rental_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Color(0xffF7F8F8),
            ),
          ),
          SizedBox(height: 16),
          
          TextField(
            decoration: InputDecoration(
              labelText: 'Vehicle Color',
              prefixIcon: Icon(Icons.palette_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Color(0xffF7F8F8),
            ),
          ),
          
          SizedBox(height: 24),
          
          // Parking Details Section
          _buildSectionTitle('Parking Details', Icons.local_parking),
          SizedBox(height: 16),
          
          // TextField(
          //   readOnly: true,
          //   decoration: InputDecoration(
          //     labelText: 'Selected Parking Zone',
          //     prefixIcon: Icon(Icons.location_on_outlined),
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     filled: true,
          //     fillColor: Colors.grey.shade100,
          //   ),
          // ),
          // SizedBox(height: 16),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Parking name',
              prefixIcon: Icon(Icons.location_searching_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Color(0xffF7F8F8),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            readOnly: true,
            decoration: InputDecoration(
              labelText: 'Parking Address',
              prefixIcon: Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Color(0xffF7F8F8),
            ),
          ),
          SizedBox(height: 16),
          
          // Subscription Plan Dropdown
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              color: Color(0xffF7F8F8),
            ),
            child: DropdownButtonFormField<String>(
              isExpanded: true, // This ensures the dropdown takes full width
              decoration: InputDecoration(
                labelText: 'Monthly Plan',
                prefixIcon: Icon(Icons.calendar_month_outlined),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              items: [
                DropdownMenuItem(
                  value: '1month', 
                  child: Text(
                    '1 Month - 1000VND',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                DropdownMenuItem(
                  value: '3months', 
                  child: Text(
                    '3 Months - 2000VND (6% off)',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                DropdownMenuItem(
                  value: '6months', 
                  child: Text(
                    '6 Months - 4000VND (10% off)',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                DropdownMenuItem(
                  value: '12months', 
                  child: Text(
                    '12 Months - 5000VND (15% off)',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
              onChanged: (value) {
                // Handle plan selection
              },
            ),
          ),
          
          SizedBox(height: 24),
          // Terms and Conditions
          Row(
            children: [
              Checkbox(
                value: true, // You can make this dynamic with state
                onChanged: (value) {
                  // Handle checkbox state
                },
              ),
              Expanded(
                child: Text(
                  'I agree to the Terms & Conditions and Privacy Policy',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 30),
          
          // Register Button
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/main');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.app_registration, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Register for Monthly Parking',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 16),
          
          // Summary Card
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Monthly Fee:', style: TextStyle(fontWeight: FontWeight.w500)),
                    Text('1000 VND', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Setup Fee:', style: TextStyle(fontWeight: FontWeight.w500)),
                    Text('2000 VND', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade700)),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('3000 VND', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue.shade700)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.blue.shade600, size: 20),
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Container _searchSection() {
    return Container(
          margin: EdgeInsets.only(top: 40, left: 20, right: 20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xff1D1617).withValues(alpha: 0.11),
                spreadRadius: 0,
                blurRadius: 40,
                // offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF7F8F8),
              hintStyle: TextStyle(
                color: Color(0xffB6B7B7),
                fontSize: 14,
              ),
              hintText: 'Search',
              contentPadding: EdgeInsets.all(20),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(  
                  Icons.search,
                  color: Color(0xffB6B7B7),
                ),
              ),
              suffixIcon: Container(
                width: 100,
                child: IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      VerticalDivider(
                        color: Colors.black,
                        indent: 10,
                        endIndent: 10,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(  
                          Icons.filter_list,
                          color: Color(0xffB6B7B7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        );
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        'Register',
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