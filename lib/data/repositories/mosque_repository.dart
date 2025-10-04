import '../models/mosque.dart';
import '../services/supabase_service.dart';
import 'dart:math' as math;

class MosqueRepository {
  final SupabaseService _supabaseService;

  MosqueRepository(this._supabaseService);

  // Get all mosques
  Future<List<Mosque>> getAllMosques() async {
    try {
      // Add debug logging
      print('🔍 Attempting to fetch mosques from Supabase...');
      print('🔍 Supabase client initialized: ${_supabaseService.client != null}');

      final response = await _supabaseService.client
          .from('mosques')
          .select()
          .order('name');

      print('✅ Successfully fetched ${(response as List).length} mosques from Supabase');

      return (response as List<dynamic>)
          .map((json) => _mapToMosque(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      // IMPORTANT: Print the actual error instead of hiding it
      print('❌ Error fetching mosques from Supabase: $e');
      print('📍 Stack trace: $stackTrace');

      // Check if it's a configuration issue
      if (e.toString().contains('Invalid API key') ||
          e.toString().contains('Invalid URL')) {
        print('⚠️ Supabase configuration error - check your API keys and URL');
      }

      print('⚠️ Falling back to sample data');
      return _getSampleMosques();
    }
  }

  // Get mosque by ID
  Future<Mosque?> getMosqueById(int id) async {
    try {
      print('🔍 Fetching mosque with ID: $id');

      final response = await _supabaseService.client
          .from('mosques')
          .select()
          .eq('id', id)
          .single();

      print('✅ Successfully fetched mosque: ${response['name']}');
      return _mapToMosque(response);
    } catch (e, stackTrace) {
      print('❌ Error fetching mosque by ID $id: $e');
      print('📍 Stack trace: $stackTrace');

      final samples = _getSampleMosques();
      try {
        return samples.firstWhere((m) => m.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  // Get mosques by governorate
  Future<List<Mosque>> getMosquesByGovernorate(String governorate) async {
    try {
      print('🔍 Fetching mosques for governorate: $governorate');

      final response = await _supabaseService.client
          .from('mosques')
          .select()
          .eq('governorate', governorate)
          .order('name');

      print('✅ Found ${(response as List).length} mosques in $governorate');

      return (response as List<dynamic>)
          .map((json) => _mapToMosque(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      print('❌ Error fetching mosques by governorate: $e');
      print('📍 Stack trace: $stackTrace');

      return _getSampleMosques()
          .where((m) => m.governorate == governorate)
          .toList();
    }
  }

  // Get mosques by type
  Future<List<Mosque>> getMosquesByType(MosqueType type) async {
    try {
      print('🔍 Fetching mosques of type: ${type.name}');

      final response = await _supabaseService.client
          .from('mosques')
          .select()
          .eq('type', type.name)
          .order('name');

      print('✅ Found ${(response as List).length} mosques of type ${type.name}');

      return (response as List<dynamic>)
          .map((json) => _mapToMosque(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      print('❌ Error fetching mosques by type: $e');
      print('📍 Stack trace: $stackTrace');

      return _getSampleMosques().where((m) => m.type == type).toList();
    }
  }

  // Search mosques
  Future<List<Mosque>> searchMosques(String query) async {
    try {
      print('🔍 Searching mosques with query: $query');

      final response = await _supabaseService.client
          .from('mosques')
          .select()
          .or('name.ilike.%$query%,name_en.ilike.%$query%,imam.ilike.%$query%')
          .order('name');

      print('✅ Found ${(response as List).length} mosques matching "$query"');

      return (response as List<dynamic>)
          .map((json) => _mapToMosque(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      print('❌ Error searching mosques: $e');
      print('📍 Stack trace: $stackTrace');

      return _getSampleMosques()
          .where((m) =>
      m.name.toLowerCase().contains(query.toLowerCase()) ||
          m.imam.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  // Get nearby mosques
  Future<List<Mosque>> getNearbyMosques(
      double latitude,
      double longitude, {
        double radiusKm = 5.0,
      }) async {
    try {
      print('🔍 Fetching mosques near ($latitude, $longitude) within ${radiusKm}km');

      final allMosques = await getAllMosques();

      final nearbyMosques = allMosques.where((mosque) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          mosque.location.latitude,
          mosque.location.longitude,
        );
        return distance <= radiusKm;
      }).toList();

      print('✅ Found ${nearbyMosques.length} mosques within radius');

      return nearbyMosques;
    } catch (e, stackTrace) {
      print('❌ Error fetching nearby mosques: $e');
      print('📍 Stack trace: $stackTrace');
      throw Exception('Failed to load nearby mosques: $e');
    }
  }

  // Get mosque statistics
  Future<Map<String, dynamic>> getMosqueStatistics() async {
    try {
      print('🔍 Calculating mosque statistics...');

      final allMosques = await getAllMosques();

      final stats = {
        'total': allMosques.length,
        'active': allMosques.where((m) => m.status == MosqueStatus.active).length,
        'by_type': {
          for (var type in MosqueType.values)
            type.name: allMosques.where((m) => m.type == type).length,
        },
        'by_governorate': {
          for (var gov in allMosques.map((m) => m.governorate).toSet())
            gov: allMosques.where((m) => m.governorate == gov).length,
        },
      };

      print('✅ Statistics calculated successfully');

      return stats;
    } catch (e, stackTrace) {
      print('❌ Error calculating statistics: $e');
      print('📍 Stack trace: $stackTrace');
      throw Exception('Failed to load mosque statistics: $e');
    }
  }

  // Map Supabase JSON to Mosque object
  Mosque _mapToMosque(Map<String, dynamic> json) {
    return Mosque(
      id: json['id'] as int,
      name: json['name'] as String,
      nameEn: json['name_en'] as String,
      description: json['description'] as String,
      type: MosqueType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => MosqueType.masjid,
      ),
      status: MosqueStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => MosqueStatus.active,
      ),
      location: MosqueLocation(
        address: json['address'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
      ),
      imam: json['imam'] as String,
      capacity: json['capacity'] as int,
      hasWheelchairAccess: json['has_wheelchair_access'] as bool? ?? false,
      hasAirConditioning: json['has_air_conditioning'] as bool? ?? false,
      hasFemaleSection: json['has_female_section'] as bool? ?? false,
      governorate: json['governorate'] as String,
      district: json['district'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  // Calculate distance using Haversine formula
  double _calculateDistance(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    const double earthRadius = 6371; // km

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.asin(math.sqrt(a));

    return earthRadius * c;
  }

  double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  // Sample data for fallback
  List<Mosque> _getSampleMosques() {
    return [
      Mosque(
        id: 1,
        name: 'المسجد الأقصى المبارك',
        nameEn: 'Al-Aqsa Mosque',
        description: 'المسجد الأقصى المبارك أولى القبلتين وثالث الحرمين الشريفين',
        type: MosqueType.jamia,
        status: MosqueStatus.active,
        location: const MosqueLocation(
          address: 'البلدة القديمة، القدس',
          latitude: 31.7782778,
          longitude: 35.2361111,
        ),
        imam: 'الشيخ عكرمة صبري',
        capacity: 5000,
        hasWheelchairAccess: true,
        hasAirConditioning: true,
        hasFemaleSection: true,
        governorate: 'القدس',
        district: 'البلدة القديمة',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Mosque(
        id: 2,
        name: 'مسجد عمر بن الخطاب',
        nameEn: 'Omar Ibn Al-Khattab Mosque',
        description: 'مسجد كبير في وسط مدينة رام الله',
        type: MosqueType.jamia,
        status: MosqueStatus.active,
        location: const MosqueLocation(
          address: 'وسط البلد، رام الله',
          latitude: 31.9037,
          longitude: 35.2034,
        ),
        imam: 'الشيخ محمد أحمد',
        capacity: 1000,
        hasWheelchairAccess: true,
        hasAirConditioning: true,
        hasFemaleSection: true,
        governorate: 'رام الله والبيرة',
        district: 'وسط البلد',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      Mosque(
        id: 3,
        name: 'مسجد صلاح الدين',
        nameEn: 'Salah Al-Din Mosque',
        description: 'مسجد تاريخي في مدينة نابلس',
        type: MosqueType.jamia,
        status: MosqueStatus.active,
        location: const MosqueLocation(
          address: 'البلدة القديمة، نابلس',
          latitude: 32.2211,
          longitude: 35.2544,
        ),
        imam: 'الشيخ خالد يوسف',
        capacity: 800,
        hasWheelchairAccess: false,
        hasAirConditioning: true,
        hasFemaleSection: true,
        governorate: 'نابلس',
        district: 'البلدة القديمة',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}