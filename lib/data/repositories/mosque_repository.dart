import '../models/mosque.dart';
import '../services/supabase_service.dart';
import 'dart:math' as math;

class MosqueRepository {
  final SupabaseService _supabaseService;

  MosqueRepository(this._supabaseService);

  // Get all mosques
  Future<List<Mosque>> getAllMosques() async {
    try {
      final response = await _supabaseService.client
          .from('mosques')
          .select()
          .order('name');

      return (response as List<dynamic>)
          .map((json) => Mosque.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Return sample data if Supabase not configured
      return _getSampleMosques();
    }
  }

  // Get mosque by ID
  Future<Mosque?> getMosqueById(int id) async {
    try {
      final response = await _supabaseService.client
          .from('mosques')
          .select()
          .eq('id', id)
          .single();

      return Mosque.fromJson(response);
    } catch (e) {
      return _getSampleMosques().firstWhere((m) => m.id == id);
    }
  }

  // Get mosques by governorate
  Future<List<Mosque>> getMosquesByGovernorate(String governorate) async {
    try {
      final response = await _supabaseService.client
          .from('mosques')
          .select()
          .eq('governorate', governorate)
          .order('name');

      return (response as List<dynamic>)
          .map((json) => Mosque.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return _getSampleMosques()
          .where((m) => m.governorate == governorate)
          .toList();
    }
  }

  // Get mosques by type
  Future<List<Mosque>> getMosquesByType(MosqueType type) async {
    try {
      final response = await _supabaseService.client
          .from('mosques')
          .select()
          .eq('type', type.name)
          .order('name');

      return (response as List<dynamic>)
          .map((json) => Mosque.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return _getSampleMosques().where((m) => m.type == type).toList();
    }
  }

  // Search mosques
  Future<List<Mosque>> searchMosques(String query) async {
    try {
      final response = await _supabaseService.client
          .from('mosques')
          .select()
          .or('name.ilike.%$query%,name_en.ilike.%$query%,imam.ilike.%$query%')
          .order('name');

      return (response as List<dynamic>)
          .map((json) => Mosque.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
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
      // In a real implementation, you'd use PostGIS functions
      final allMosques = await getAllMosques();

      return allMosques.where((mosque) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          mosque.location.latitude,
          mosque.location.longitude,
        );
        return distance <= radiusKm;
      }).toList();
    } catch (e) {
      throw Exception('Failed to load nearby mosques: $e');
    }
  }

  // Get mosque statistics
  Future<Map<String, dynamic>> getMosqueStatistics() async {
    try {
      final allMosques = await getAllMosques();

      return {
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
    } catch (e) {
      throw Exception('Failed to load mosque statistics: $e');
    }
  }


// In the _calculateDistance method:
  double _calculateDistance(
      double lat1,
      double lon1,
      double lat2,
      double lon2,
      ) {
    // Haversine formula implementation
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

  // Sample data
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
    ];
  }
}