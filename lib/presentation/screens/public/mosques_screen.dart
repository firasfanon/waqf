import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/mosque.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/search_bar_widget.dart';

class MosquesScreen extends StatefulWidget {
  const MosquesScreen({super.key});

  @override
  State<MosquesScreen> createState() => _MosquesScreenState();
}

class _MosquesScreenState extends State<MosquesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String? _selectedGovernorate;
  MosqueType? _selectedType;
  bool _isMapView = false;

  final List<Mosque> _mosques = _getSampleMosques();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'دليل المساجد',
        showSearchButton: true,
        actions: [
          IconButton(
            icon: Icon(_isMapView ? Icons.list : Icons.map),
            onPressed: () => setState(() => _isMapView = !_isMapView),
            tooltip: _isMapView ? 'عرض القائمة' : 'عرض الخريطة',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filters
          _buildSearchAndFilters(),

          // Content
          Expanded(
            child: _isMapView ? _buildMapView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      color: Colors.grey[50],
      child: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            hintText: 'البحث في المساجد...',
            onChanged: (value) => setState(() => _searchQuery = value),
          ),

          const SizedBox(height: 12),

          // Filters
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedGovernorate,
                  decoration: const InputDecoration(
                    labelText: 'المحافظة',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: AppConstants.governorates.map((gov) {
                    return DropdownMenuItem(value: gov, child: Text(gov));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedGovernorate = value),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: DropdownButtonFormField<MosqueType>(
                  initialValue: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'النوع',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: MosqueType.values.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.displayName),
                    );
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedType = value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final filteredMosques = _getFilteredMosques();

    if (filteredMosques.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      itemCount: filteredMosques.length,
      itemBuilder: (context, index) {
        return _buildMosqueCard(filteredMosques[index]);
      },
    );
  }

  Widget _buildMapView() {
    final filteredMosques = _getFilteredMosques();

    return GoogleMap(
      initialCameraPosition: const CameraPosition(
        target: LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
        zoom: AppConstants.defaultZoom,
      ),
      markers: filteredMosques.map((mosque) {
        return Marker(
          markerId: MarkerId(mosque.id.toString()),
          position: LatLng(mosque.location.latitude, mosque.location.longitude),
          infoWindow: InfoWindow(
            title: mosque.name,
            snippet: mosque.location.address,
          ),
          onTap: () => _showMosqueDetails(mosque),
        );
      }).toSet(),
    );
  }

  Widget _buildMosqueCard(Mosque mosque) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
      child: InkWell(
        onTap: () => _showMosqueDetails(mosque),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getTypeColor(mosque.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      mosque.type.displayName,
                      style: TextStyle(
                        color: _getTypeColor(mosque.type),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(mosque.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      mosque.status.displayName,
                      style: TextStyle(
                        color: _getStatusColor(mosque.status),
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Name and Location
              Text(
                mosque.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      mosque.location.address,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Imam and Capacity
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'الإمام: ${mosque.imam}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (mosque.capacity > 0) ...[
                    const Icon(Icons.group, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${mosque.capacity} مصلي',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 12),

              // Features
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _buildFeatureChips(mosque),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFeatureChips(Mosque mosque) {
    final features = <Widget>[];

    if (mosque.hasWheelchairAccess) {
      features.add(_buildFeatureChip('مناسب للكراسي المتحركة', Icons.accessible));
    }

    if (mosque.hasParkingSpace) {
      features.add(_buildFeatureChip('مواقف سيارات', Icons.local_parking));
    }

    if (mosque.hasAirConditioning) {
      features.add(_buildFeatureChip('مكيف', Icons.ac_unit));
    }

    if (mosque.hasFemaleSection) {
      features.add(_buildFeatureChip('قسم نساء', Icons.female));
    }

    if (mosque.hasLibrary) {
      features.add(_buildFeatureChip('مكتبة', Icons.library_books));
    }

    if (mosque.hasEducationCenter) {
      features.add(_buildFeatureChip('مركز تعليمي', Icons.school));
    }

    return features;
  }

  Widget _buildFeatureChip(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      backgroundColor: AppColors.islamicGreen.withOpacity(0.1),
      labelStyle: const TextStyle(
        fontSize: 10,
        color: AppColors.islamicGreen,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mosque,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد مساجد',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على مساجد تطابق البحث',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _showMosqueDetails(Mosque mosque) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MosqueDetailsBottomSheet(mosque: mosque),
    );
  }

  List<Mosque> _getFilteredMosques() {
    return _mosques.where((mosque) {
      final matchesSearch = _searchQuery.isEmpty ||
          mosque.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          mosque.location.address.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          mosque.imam.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesGovernorate = _selectedGovernorate == null ||
          mosque.governorate == _selectedGovernorate;

      final matchesType = _selectedType == null ||
          mosque.type == _selectedType;

      return matchesSearch && matchesGovernorate && matchesType;
    }).toList();
  }

  Color _getTypeColor(MosqueType type) {
    switch (type) {
      case MosqueType.jamia:
        return AppColors.islamicGreen;
      case MosqueType.masjid:
        return AppColors.goldenYellow;
      case MosqueType.musalla:
        return AppColors.info;
      case MosqueType.historical:
        return AppColors.sageGreen;
    }
  }

  Color _getStatusColor(MosqueStatus status) {
    switch (status) {
      case MosqueStatus.active:
        return AppColors.success;
      case MosqueStatus.underConstruction:
        return AppColors.warning;
      case MosqueStatus.underRenovation:
        return AppColors.info;
      case MosqueStatus.closed:
        return AppColors.error;
      case MosqueStatus.historical:
        return AppColors.sageGreen;
    }
  }

  static List<Mosque> _getSampleMosques() {
    return [
      Mosque(
        id: 1,
        name: 'المسجد الأقصى المبارك',
        description: 'أولى القبلتين وثالث الحرمين الشريفين',
        type: MosqueType.jamia,
        status: MosqueStatus.active,
        location: const MosqueLocation(
          address: 'البلدة القديمة، القدس',
          latitude: 31.7781,
          longitude: 35.2360,
          nearbyLandmarks: 'قبة الصخرة، حائط البراق',
        ),
        imam: 'الشيخ محمد حسين',
        capacity: 5000,
        hasParkingSpace: false,
        hasWheelchairAccess: true,
        hasAirConditioning: false,
        hasFemaleSection: true,
        hasLibrary: true,
        hasEducationCenter: true,
        services: ['صلاة الجماعة', 'دروس دينية', 'خطبة الجمعة'],
        programs: ['تحفيظ القرآن', 'الدروس الدينية', 'المحاضرات'],
        establishedDate: DateTime(692),
        governorate: 'القدس',
        district: 'البلدة القديمة',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      Mosque(
        id: 2,
        name: 'مسجد النور',
        description: 'مسجد حديث في قلب رام الله',
        type: MosqueType.masjid,
        status: MosqueStatus.active,
        location: const MosqueLocation(
          address: 'شارع الطيرة، رام الله',
          latitude: 31.9026,
          longitude: 35.2042,
        ),
        imam: 'الشيخ أحمد محمد',
        capacity: 800,
        hasParkingSpace: true,
        hasWheelchairAccess: true,
        hasAirConditioning: true,
        hasFemaleSection: true,
        hasLibrary: false,
        hasEducationCenter: true,
        services: ['صلاة الجماعة', 'دروس دينية', 'خطبة الجمعة'],
        programs: ['تحفيظ القرآن', 'دورات تدريبية'],
        governorate: 'رام الله والبيرة',
        district: 'رام الله',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),

      Mosque(
        id: 3,
        name: 'جامع السلام',
        description: 'جامع تاريخي في نابلس',
        type: MosqueType.jamia,
        status: MosqueStatus.historical,
        location: const MosqueLocation(
          address: 'البلدة القديمة، نابلس',
          latitude: 32.2211,
          longitude: 35.2544,
        ),
        imam: 'الشيخ يوسف عبد الله',
        capacity: 1200,
        hasParkingSpace: false,
        hasWheelchairAccess: false,
        hasAirConditioning: false,
        hasFemaleSection: true,
        hasLibrary: true,
        hasEducationCenter: false,
        services: ['صلاة الجماعة', 'خطبة الجمعة'],
        programs: ['تحفيظ القرآن'],
        establishedDate: DateTime(1400),
        governorate: 'نابلس',
        district: 'البلدة القديمة',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];
  }
}

class MosqueDetailsBottomSheet extends StatelessWidget {
  final Mosque mosque;

  const MosqueDetailsBottomSheet({super.key, required this.mosque});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.radiusL),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Title
                  Text(
                    mosque.name,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (mosque.description.isNotEmpty)
                    Text(
                      mosque.description,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),

                  const SizedBox(height: 20),

                  // Location
                  _buildDetailSection(
                    'الموقع',
                    Icons.location_on,
                    mosque.location.address,
                  ),

                  // Imam
                  _buildDetailSection(
                    'الإمام',
                    Icons.person,
                    mosque.imam,
                  ),

                  // Capacity
                  if (mosque.capacity > 0)
                    _buildDetailSection(
                      'السعة',
                      Icons.group,
                      '${mosque.capacity} مصلي',
                    ),

                  // Features
                  if (mosque.services.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      'الخدمات',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...mosque.services.map((service) => Text('• $service')),
                  ],

                  const SizedBox(height: 20),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Open maps with location
                          },
                          icon: const Icon(Icons.directions),
                          label: const Text('الاتجاهات'),
                        ),
                      ),

                      const SizedBox(width: 12),

                      if (mosque.imamPhone != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // Make phone call
                            },
                            icon: const Icon(Icons.phone),
                            label: const Text('اتصال'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(String title, IconData icon, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.islamicGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  content,
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}