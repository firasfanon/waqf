import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../data/models/mosque.dart';
import '../../../widgets/common/custom_app_bar.dart';
import '../../../widgets/common/search_bar_widget.dart';
import '../../../providers/mosque_providers.dart';

class MosquesScreen extends ConsumerStatefulWidget {
  const MosquesScreen({super.key});

  @override
  ConsumerState<MosquesScreen> createState() => _MosquesScreenState();
}

class _MosquesScreenState extends ConsumerState<MosquesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String? _selectedGovernorate;
  MosqueType? _selectedType;
  bool _isMapView = false;

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
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('الكل'),
                    ),
                    ...AppConstants.governorates.map((gov) {
                      return DropdownMenuItem(value: gov, child: Text(gov));
                    }),
                  ],
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
                  items: [
                    const DropdownMenuItem<MosqueType>(
                      value: null,
                      child: Text('الكل'),
                    ),
                    ...MosqueType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.displayName),
                      );
                    }),
                  ],
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
    final mosquesAsync = ref.watch(allMosquesProvider);

    return mosquesAsync.when(
      data: (mosques) {
        final filteredMosques = _getFilteredMosques(mosques);

        if (filteredMosques.isEmpty) {
          return _buildEmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(allMosquesProvider);
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            itemCount: filteredMosques.length,
            itemBuilder: (context, index) {
              return _buildMosqueCard(filteredMosques[index]);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text('حدث خطأ: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(allMosquesProvider),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapView() {
    final mosquesAsync = ref.watch(allMosquesProvider);

    return mosquesAsync.when(
      data: (mosques) {
        final filteredMosques = _getFilteredMosques(mosques);

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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('حدث خطأ في تحميل الخريطة: $error'),
      ),
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

    if (mosque.hasAirConditioning) {
      features.add(_buildFeatureChip('مكيف', Icons.ac_unit));
    }

    if (mosque.hasFemaleSection) {
      features.add(_buildFeatureChip('قسم نساء', Icons.female));
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

  List<Mosque> _getFilteredMosques(List<Mosque> mosques) {
    return mosques.where((mosque) {
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
    return switch (status) {
      MosqueStatus.active => AppColors.success,
    // TODO: Handle this case.
      MosqueStatus.historical => throw UnimplementedError(),
      MosqueStatus.underConstruction => AppColors.warning,
      MosqueStatus.underRenovation => AppColors.info,
      MosqueStatus.inactive => AppColors.error,
    // TODO: Handle this case.
      MosqueStatus.closed => throw UnimplementedError(),

    };
  }
}

// MosqueDetailsBottomSheet remains the same...
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