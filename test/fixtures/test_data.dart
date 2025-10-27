/// Test fixtures and sample data for unit and widget tests

// Sample News Article Data
const Map<String, dynamic> sampleNewsArticleJson = {
  'id': 'news-1',
  'title': 'افتتاح مسجد جديد في رام الله',
  'content': 'تم افتتاح مسجد جديد في مدينة رام الله بحضور وزير الأوقاف',
  'category': 'مساجد',
  'author': 'وزارة الأوقاف',
  'published_at': '2025-01-15T10:00:00Z',
  'image_url': 'https://example.com/mosque.jpg',
  'is_featured': true,
  'view_count': 150,
};

// Sample Mosque Data
const Map<String, dynamic> sampleMosqueJson = {
  'id': 'mosque-1',
  'name': 'المسجد الأقصى',
  'address': 'القدس الشريف',
  'governorate': 'القدس',
  'latitude': 31.7781,
  'longitude': 35.2353,
  'imam_name': 'الشيخ محمد أحمد',
  'imam_phone': '+970599123456',
  'capacity': 5000,
  'has_parking': true,
  'has_library': true,
  'description': 'أولى القبلتين وثالث الحرمين الشريفين',
};

// Sample User Data
const Map<String, dynamic> sampleUserJson = {
  'id': 'user-1',
  'email': 'admin@awqaf.ps',
  'full_name': 'أحمد محمد',
  'role': 'admin',
  'phone': '+970599123456',
  'created_at': '2024-01-01T00:00:00Z',
};

// Sample Announcement Data
const Map<String, dynamic> sampleAnnouncementJson = {
  'id': 'announcement-1',
  'title': 'إعلان هام',
  'content': 'تعلن وزارة الأوقاف عن موعد صلاة العيد',
  'priority': 'high',
  'published_at': '2025-01-15T08:00:00Z',
  'expires_at': '2025-01-20T23:59:59Z',
};

// Sample Activity/Event Data
const Map<String, dynamic> sampleActivityJson = {
  'id': 'activity-1',
  'title': 'محاضرة دينية',
  'description': 'محاضرة في التفسير والحديث',
  'category': 'دينية',
  'location': 'مسجد عمر بن الخطاب - رام الله',
  'start_date': '2025-02-01T18:00:00Z',
  'end_date': '2025-02-01T20:00:00Z',
  'max_attendees': 100,
  'registered_count': 45,
  'is_registration_open': true,
};

// Sample Waqf Land Data
const Map<String, dynamic> sampleWaqfLandJson = {
  'id': 'waqf-1',
  'name': 'أرض وقف المسجد',
  'location': 'نابلس',
  'area_sqm': 5000.0,
  'land_type': 'زراعية',
  'status': 'active',
  'annual_revenue': 10000.0,
  'coordinates': {
    'latitude': 32.2211,
    'longitude': 35.2544,
  },
};

// Sample Legal Case Data
const Map<String, dynamic> sampleCaseJson = {
  'id': 'case-1',
  'case_number': 'C-2025-001',
  'title': 'قضية وقف',
  'description': 'قضية متعلقة بأرض وقف',
  'status': 'open',
  'priority': 'medium',
  'assigned_to': 'user-1',
  'created_at': '2025-01-10T00:00:00Z',
  'updated_at': '2025-01-15T00:00:00Z',
};

// List of Palestinian Governorates
const List<String> palestinianGovernorates = [
  'القدس',
  'رام الله والبيرة',
  'نابلس',
  'الخليل',
  'بيت لحم',
  'أريحا والأغوار',
  'قلقيلية',
  'سلفيت',
  'طولكرم',
  'جنين',
  'طوباس والأغوار الشمالية',
  'غزة',
  'خان يونس',
  'دير البلح',
  'رفح',
  'شمال غزة',
];

// Sample Error Messages
const Map<String, String> sampleErrorMessages = {
  'network_error': 'لا يوجد اتصال بالإنترنت',
  'auth_error': 'فشل تسجيل الدخول',
  'not_found': 'لم يتم العثور على البيانات',
  'server_error': 'خطأ في الخادم',
};

// Sample Success Messages
const Map<String, String> sampleSuccessMessages = {
  'data_loaded': 'تم تحميل البيانات بنجاح',
  'data_saved': 'تم حفظ البيانات بنجاح',
  'login_success': 'تم تسجيل الدخول بنجاح',
};

// Helper function to create multiple test items
List<Map<String, dynamic>> createMultipleNewsArticles(int count) {
  return List.generate(
    count,
    (index) => {
      ...sampleNewsArticleJson,
      'id': 'news-$index',
      'title': 'خبر رقم $index',
      'view_count': 100 + index,
    },
  );
}

List<Map<String, dynamic>> createMultipleMosques(int count) {
  return List.generate(
    count,
    (index) => {
      ...sampleMosqueJson,
      'id': 'mosque-$index',
      'name': 'مسجد رقم $index',
      'capacity': 100 + (index * 50),
    },
  );
}
