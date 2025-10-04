# Palestinian Ministry of Endowments Flutter App

وزارة الأوقاف والشؤون الدينية الفلسطينية

A comprehensive enterprise-grade mobile and web application for the Palestinian Ministry of Endowments and Religious Affairs.

## 📱 Overview

This Flutter application serves as the official digital platform for the Palestinian Ministry of Endowments and Religious Affairs (وزارة الأوقاف والشؤون الدينية الفلسطينية), providing citizens with access to ministry services, news, mosque directories, and administrative functions.

### 🎯 Key Features

- **Bilingual Support**: Full Arabic (RTL) and English language support
- **Islamic Design**: Culturally appropriate UI with Palestinian identity
- **Comprehensive Services**: Digital access to all ministry services
- **Mosque Directory**: Complete mosque listings with maps and details
- **News & Announcements**: Latest ministry news and official announcements
- **Activities & Events**: Religious and cultural events management
- **Admin Dashboard**: Complete administrative backend
- **Offline Support**: Core functionality available offline
- **Push Notifications**: Real-time updates and alerts

## 🏗️ Architecture

### Technical Stack
- **Framework**: Flutter 3.24+ with Dart 3.5+
- **State Management**: Riverpod 2.x
- **Backend**: Supabase (PostgreSQL + Real-time + Auth + Storage)
- **Maps**: Google Maps Flutter
- **Notifications**: Firebase Cloud Messaging
- **Charts**: FL Chart & Syncfusion
- **Animations**: Lottie & Staggered Animations

### Project Structure
```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── core/
│   ├── constants/
│   ├── utils/
│   ├── services/
│   └── extensions/
├── data/
│   ├── models/
│   ├── repositories/
│   ├── services/
│   └── providers/
├── presentation/
│   ├── screens/
│   │   ├── public/
│   │   └── admin/
│   ├── widgets/
│   └── providers/
└── l10n/
```

## 🚀 Getting Started

### Prerequisites
- Flutter 3.13.0 or higher
- Dart 3.1.0 or higher
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/your-org/palestinian-ministry-endowments.git
cd palestinian-ministry-endowments
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code**
```bash
flutter packages pub run build_runner build
```

4. **Configure Firebase**
    - Create a new Firebase project
    - Add your Android/iOS apps
    - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
    - Place them in the appropriate directories

5. **Configure Supabase**
    - Create a Supabase project
    - Update the URL and API key in `lib/core/constants/app_constants.dart`

6. **Run the application**
```bash
flutter run
```

## 📋 Features Overview

### Public App Features

#### 🏠 Home Screen
- Hero slider with ministry highlights
- Minister's message section
- Quick statistics display
- Latest news preview
- Priority announcements
- Service categories
- Upcoming events
- Contact information

#### 📰 News & Media
- News listing with categories
- Search and filter functionality
- Article details with sharing
- Featured articles
- Bookmark system
- Multiple view modes (grid/list)

#### 🕌 Mosque Directory
- Comprehensive mosque listings
- Interactive map integration
- Detailed mosque information
- Imam contact details
- Facility information
- Prayer time integration
- Directions and navigation

#### 🎯 Services Portal
- Digital service applications
- E-services with forms
- Application tracking
- Document upload
- Service status monitoring
- Help and support

#### 📅 Activities & Events
- Event listings by status
- Registration system
- Category filtering
- Event details
- Calendar integration
- Notification reminders

### Administrative Features

#### 📊 Dashboard
- Real-time statistics
- Interactive charts
- Quick actions
- Recent activity feed
- System health monitoring
- Performance metrics

#### ⚖️ Case Management
- Legal case tracking
- Document attachments
- Timeline management
- Assignment system
- Status workflows
- Reporting tools

#### 🏛️ Waqf Land Registry
- Property management
- Geographic information
- Financial tracking
- Legal documentation
- Boundary mapping
- Valuation records

#### 📁 Document Management
- Digital archive system
- OCR text extraction
- Full-text search
- Version control
- Access management
- Metadata enrichment

#### 👥 User Management
- Role-based permissions
- Account management
- Activity monitoring
- Security settings
- Audit logs

## 🛠️ Development

### Code Generation
The project uses code generation for models and localization:

```bash
# Generate models
flutter packages pub run build_runner build

# Watch for changes
flutter packages pub run build_runner watch

# Clean and rebuild
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Running Tests
```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test/

# Coverage
flutter test --coverage
```

### Building for Production

#### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

## 🌐 Localization

The app supports Arabic (primary) and English (secondary) languages:

- Arabic text with RTL layout
- Islamic calendar support
- Arabic numerals option
- Cultural date formatting
- Palestinian governorates data

### Adding New Translations
1. Add new strings to `lib/l10n/app_ar.arb` and `lib/l10n/app_en.arb`
2. Run code generation
3. Use in code with `context.l10n.stringKey`

## 🔐 Security Features

- JWT-based authentication
- Role-based access control
- Data encryption at rest
- Secure API communication
- Session management
- Audit logging
- Input validation
- SQL injection protection

## 📱 Supported Platforms

- **Android**: API level 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Web**: Modern browsers with PWA support
- **Desktop**: Windows, macOS, Linux (future)

## 🎨 Design System

### Colors
- **Islamic Green**: #22C55E (Primary)
- **Golden Yellow**: #EAB308 (Secondary)
- **Sage Green**: #5A7A5A (Accent)
- **Palestinian Flag Colors**: For cultural elements

### Typography
- **Arabic Display**: Amiri font family
- **Arabic Body**: Noto Sans Arabic
- **English**: Inter font family

### Components
- Material 3 design system
- Islamic geometric patterns
- Palestinian cultural elements
- Accessibility compliant
- Dark mode support

## 📊 Performance

### Optimization
- Image caching and optimization
- Lazy loading for lists
- Database query optimization
- Network request batching
- Background sync
- Memory management

### Monitoring
- Crash reporting
- Performance metrics
- User analytics
- Error tracking
- Network monitoring

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the project root:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GOOGLE_MAPS_API_KEY=your_google_maps_key
FIREBASE_PROJECT_ID=your_firebase_project_id
```

### App Configuration
Update `lib/core/constants/app_constants.dart` with your specific settings:
- API endpoints
- Feature flags
- Regional settings
- Contact information

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines
- Follow Flutter best practices
- Write comprehensive tests
- Update documentation
- Use semantic commit messages
- Ensure RTL layout compatibility

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Development Team**: Palestinian Ministry of Endowments IT Department
- **Design Team**: Cultural Design Consultants
- **Product Owner**: Ministry Technical Committee
- **Stakeholders**: Palestinian Citizens & Ministry Staff

## 📞 Support

For technical support or questions:

- **Email**: support@awqaf.ps
- **Phone**: +970-2-2406340
- **Website**: https://www.awqaf.ps
- **Documentation**: https://docs.awqaf.ps

## 🗺️ Roadmap

### Version 1.1 (Q2 2024)
- [ ] Prayer times integration
- [ ] Islamic calendar events
- [ ] Voice search in Arabic
- [ ] Biometric authentication

### Version 1.2 (Q3 2024)
- [ ] AI-powered chatbot
- [ ] Advanced analytics
- [ ] Multi-language support expansion
- [ ] Desktop applications

### Version 2.0 (Q4 2024)
- [ ] Blockchain document verification
- [ ] IoT mosque monitoring
- [ ] Advanced GIS features
- [ ] Machine learning recommendations

## 🙏 Acknowledgments

- Palestinian Ministry of Endowments and Religious Affairs
- Flutter Community
- Open Source Contributors
- Cultural Design Advisors
- Beta Testing Community

---

**وزارة الأوقاف والشؤون الدينية الفلسطينية**  
*Serving the Palestinian Islamic Community through Technology*