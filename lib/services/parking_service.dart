// import '../services/api_service.dart';

// class ParkingService {
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
//   static Future<Map<String, dynamic>> getParkingLotDetails(String lotId) async {
//     try {
//       final response = await ApiService.get('/parking/lots/$lotId');
      
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

//   // Get parked vehicles - using your parked_vehicles blueprint
//   static Future<List<Map<String, dynamic>>> getParkedVehicles(String lotId) async {
//     try {
//       final response = await ApiService.get('/parked_vehicles/lot/$lotId');
      
//       if (response is List) {
//         return List<Map<String, dynamic>>.from(response);
//       } else if (response['data'] is List) {
//         return List<Map<String, dynamic>>.from(response['data']);
//       } else {
//         // If response is a single object, wrap it in a list
//         return [Map<String, dynamic>.from(response)];
//       }
//     } catch (e) {
//       throw Exception('Failed to get parked vehicles: $e');
//     }
//   }

//   // Get environment data - using your environments blueprint
//   static Future<Map<String, dynamic>> getEnvironmentData(String lotId) async {
//     try {
//       final response = await ApiService.get('/environments/lot/$lotId');
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