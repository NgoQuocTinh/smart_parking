import '../services/api_service.dart';

class ParkingService {
  // Get parking ID by address and parking name
  static Future<String> getParkingId(String address, String parkingName) async {
    final data = {
      'address': address,
      'parking_name': parkingName,
    };
    
    try {
      final response = await ApiService.post('/parking/get_parking_id', data);
      
      if (response['status'] == 'success') {
        return response['parking_id'];
      } else {
        throw Exception(response['message'] ?? 'Parking not found');
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get parking slots and parse counts for UI display
  static Future<Map<String, dynamic>> getParkingSlots(String parkingId) async {
    final data = {
      'parking_id': parkingId,
    };
    
    try {
      final response = await ApiService.post('/parking_slots/get_parking_slots', data);
      
      if (response['status'] == 'success') {
        Map<String, dynamic> slotsData = response['data'];
        
        // Parse actual response format:
        // - available_list: array of available slot IDs
        // - occupied_list: array of occupied slot IDs  
        // - occupied_license_list: array of license plates
        
        List<dynamic> availableSlots = slotsData['available_list'] ?? [];
        List<dynamic> occupiedSlots = slotsData['occupied_list'] ?? [];
        List<dynamic> occupiedLicenses = slotsData['occupied_license_list'] ?? [];
        
        int emptyCount = availableSlots.length;
        int occupiedCount = occupiedSlots.length;
        int totalCount = emptyCount + occupiedCount;
        
        print('Parsed slots - Available: $emptyCount, Occupied: $occupiedCount, Total: $totalCount');
        print('License plates: $occupiedLicenses');
        
        // Return parsed data for UI
        return {
          'empty': emptyCount,
          'parked': occupiedCount,
          'total': totalCount,
          'licenses': occupiedLicenses.map((license) => license.toString()).toList(),
          'available_slots': availableSlots,
          'occupied_slots': occupiedSlots,
          'last_update': slotsData['last_update'] ?? '',
          'parking_id': slotsData['parking_id'] ?? '',
        };
      } else {
        throw Exception(response['message'] ?? 'Failed to get parking slots');
      }
    } catch (e) {
      rethrow;
    }
  }

//   // Get all parking lots - using your parking blueprint
//   static Future<List<Map<String, dynamic>>> getParkingLots() async {
//     try {
//       final response = await ApiService.get('/parking/lots');
      
//       // Adjust based on your API response format
//       if (response is List) {
//         return List<Map<String, dynamic>>.from(response);
//       } else if (response is Map && response['data'] is List) {
//         return List<Map<String, dynamic>>.from(response['data']);
//       } else {
//         // If response is a single object, wrap it in a list
//         return [response];
//       }
//     } catch (e) {
//       throw Exception('Failed to get parking lots: $e');
//     }
//   }

//   // Get specific parking lot details
//   static Future<Map<String, dynamic>> getParkingLotDetails(String parkingId) async {
//     try {
//       final response = await ApiService.get('/parking/details/$parkingId');
      
//       if (response['data'] != null) {
//         return response['data'];
//       } else {
//         return response;
//       }
//     } catch (e) {
//       throw Exception('Failed to get parking lot details: $e');
//     }
//   }

//   // Get parking slots - using your parking_slots blueprint
//   static Future<List<Map<String, dynamic>>> getParkingSlots(String lotId) async {
//     try {
//       final response = await ApiService.get('/parking_slots/lot/$lotId');
      
//       if (response is List) {
//         return List<Map<String, dynamic>>.from(response);
//       } else if (response['data'] is List) {
//         return List<Map<String, dynamic>>.from(response['data']);
//       } else {
//         // If response is a single object, wrap it in a list
//         return [response];
//       }
//     } catch (e) {
//       throw Exception('Failed to get parking slots: $e');
//     }
//   }

//   // Create parking session
//   static Future<Map<String, dynamic>> createParkingSession(Map<String, dynamic> sessionData) async {
//     try {
//       final response = await ApiService.post('/parking/sessions', sessionData);
//       return response;
//     } catch (e) {
//       throw Exception('Failed to create parking session: $e');
//     }
//   }

//   // Get user's parking history - using your histories blueprint
//   static Future<List<Map<String, dynamic>>> getUserParkingHistory(String userId) async {
//     try {
//       final response = await ApiService.get('/histories/user/$userId');
      
//       if (response is List) {
//         return List<Map<String, dynamic>>.from(response);
//       } else if (response['data'] is List) {
//         return List<Map<String, dynamic>>.from(response['data']);
//       } else {
//         // If response is a single object, wrap it in a list
//         return [response];
//       }
//     } catch (e) {
//       throw Exception('Failed to get parking history: $e');
//     }
//   }

//   // Get parked vehicles - for licenses display in home page  
//   static Future<List<String>> getParkedVehicles(String parkingId) async {
//     try {
//       final response = await ApiService.get('/parked_vehicles/lot/$parkingId');
      
//       List<dynamic> vehicles = [];
//       if (response['data'] is List) {
//         vehicles = response['data'];
//       } else if (response is List) {
//         vehicles = response as List<dynamic>;
//       }
      
//       return vehicles.map((vehicle) => vehicle['license_plate']?.toString() ?? '').toList();
//     } catch (e) {
//       throw Exception('Failed to get parked vehicles: $e');
//     }
//   }

//   // Get environment data - for temperature, humidity, light display
//   static Future<Map<String, dynamic>> getEnvironmentData(String parkingId) async {
//     try {
//       final response = await ApiService.get('/environments/lot/$parkingId');
//       return response;
//     } catch (e) {
//       throw Exception('Failed to get environment data: $e');
//     }
//   }

//   // Get coordinates - using your coordinates blueprint
//   static Future<Map<String, dynamic>> getCoordinates(String lotId) async {
//     try {
//       final response = await ApiService.get('/coordinates/lot/$lotId');
//       return response;
//     } catch (e) {
//       throw Exception('Failed to get coordinates: $e');
//     }
//   }

//   // Register monthly parking - using your registers blueprint
//   static Future<Map<String, dynamic>> registerMonthlyParking(Map<String, dynamic> registrationData) async {
//     try {
//       final response = await ApiService.post('/registers/monthly', registrationData);
//       return response;
//     } catch (e) {
//       throw Exception('Failed to register monthly parking: $e');
//     }
//   }

//   // Customer related operations - using your customers blueprint
//   static Future<Map<String, dynamic>> getCustomerInfo(String customerId) async {
//     try {
//       final response = await ApiService.get('/customers/$customerId');
//       return response;
//     } catch (e) {
//       throw Exception('Failed to get customer info: $e');
//     }
//   }

//   // Update customer info
//   static Future<Map<String, dynamic>> updateCustomerInfo(String customerId, Map<String, dynamic> customerData) async {
//     try {
//       final response = await ApiService.put('/customers/$customerId', customerData);
//       return response;
//     } catch (e) {
//       throw Exception('Failed to update customer info: $e');
//     }
//   }
// }
}