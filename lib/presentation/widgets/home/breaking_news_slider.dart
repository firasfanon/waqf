// lib/presentation/widgets/home/breaking_news_slider.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/homepage_section.dart';
import '../../../presentation/providers/homepage_settings_provider.dart';

/// Breaking News Ticker Slider
/// Displays breaking news in a scrolling ticker format
/// Follows DRY and OOP principles
class BreakingNewsSlider extends ConsumerStatefulWidget {
  const BreakingNewsSlider({super.key});

  @override
  ConsumerState<BreakingNewsSlider> createState() => _BreakingNewsSliderState();
}

class _BreakingNewsSliderState extends ConsumerState<BreakingNewsSlider>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  bool _isHovered = false;
  bool _isScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll(BreakingNewsSectionSettings settings) {
    if (!settings.autoScroll ||
        _scrollController.hasClients == false ||
        _isScrolling ||
        _isHovered) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    _isScrolling = true;

    final duration = Duration(
      milliseconds: (maxScroll / settings.scrollSpeed * 1000).toInt(),
    );

    _scrollController
        .animateTo(
          maxScroll,
          duration: duration,
          curve: Curves.linear,
        )
        .then((_) {
      if (mounted && !_isHovered) {
        Future.delayed(
          Duration(milliseconds: settings.pauseDuration),
              () {
            if (mounted && _scrollController.hasClients) {
              // Smoothly return to start
              _scrollController
                  .animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  )
                  .then((_) {
                _isScrolling = false;
                if (mounted && !_isHovered) {
                  _startAutoScroll(settings);
                }
              });
            }
          },
        );
      } else {
        _isScrolling = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final breakingNewsAsync = ref.watch(activeBreakingNewsProvider);
    final settingsState = ref.watch(breakingNewsSectionNotifierProvider);

    return breakingNewsAsync.when(
      data: (items) {
        if (items.isEmpty || settingsState.settings?.enabled == false) {
          return const SizedBox.shrink();
        }

        final settings = settingsState.settings!;

        // Start auto-scroll after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (settings.autoScroll && !_isHovered) {
            _startAutoScroll(settings);
          }
        });

        return _BreakingNewsBar(
          items: items,
          settings: settings,
          scrollController: _scrollController,
          onHoverChanged: (isHovered) {
            setState(() => _isHovered = isHovered);
            if (!isHovered) {
              _startAutoScroll(settings);
            }
          },
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Breaking News Bar Component (Separated for reusability)
class _BreakingNewsBar extends StatelessWidget {
  final List<BreakingNewsItem> items;
  final BreakingNewsSectionSettings settings;
  final ScrollController scrollController;
  final ValueChanged<bool> onHoverChanged;

  const _BreakingNewsBar({
    required this.items,
    required this.settings,
    required this.scrollController,
    required this.onHoverChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.error,
            AppConstants.error.withOpacity(0.9),
          ],
        ),
        border: settings.showBorder
            ? Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 2,
          ),
        )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: MouseRegion(
        onEnter: (_) => onHoverChanged(true),
        onExit: (_) => onHoverChanged(false),
        child: Row(
          children: [
            // Breaking News Label
            _BreakingNewsLabel(
              showIcon: settings.showIcon,
              iconName: settings.defaultIcon,
            ),

            // Scrolling News Content
            Expanded(
              child: _ScrollingNewsContent(
                items: items,
                settings: settings,
                scrollController: scrollController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Breaking News Label (Fixed on left)
class _BreakingNewsLabel extends StatelessWidget {
  final bool showIcon;
  final String iconName;

  const _BreakingNewsLabel({
    required this.showIcon,
    required this.iconName,
  });

  IconData _getIcon(String name) {
    final iconMap = {
      'campaign': Icons.campaign,
      'notifications': Icons.notifications_active,
      'warning': Icons.warning,
      'info': Icons.info,
      'flash': Icons.flash_on,
    };
    return iconMap[name] ?? Icons.campaign;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.circular(0),
        ),
      ),
      child: Row(
        children: [
          if (showIcon) ...[
            Icon(
              _getIcon(iconName),
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
          ],
          const Text(
            'عاجل',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

/// Scrolling News Content
class _ScrollingNewsContent extends StatelessWidget {
  final List<BreakingNewsItem> items;
  final BreakingNewsSectionSettings settings;
  final ScrollController scrollController;

  const _ScrollingNewsContent({
    required this.items,
    required this.settings,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: items.length * 3, // Repeat for seamless scrolling
      separatorBuilder: (context, index) {
        if (!settings.showSeparator) return const SizedBox(width: 40);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            settings.separatorText,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
      itemBuilder: (context, index) {
        final item = items[index % items.length];
        return _BreakingNewsItemWidget(
          item: item,
          settings: settings,
        );
      },
    );
  }
}

/// Individual Breaking News Item Widget
class _BreakingNewsItemWidget extends StatelessWidget {
  final BreakingNewsItem item;
  final BreakingNewsSectionSettings settings;

  const _BreakingNewsItemWidget({
    required this.item,
    required this.settings,
  });

  Color _parseColor(String hexColor) {
    try {
      return Color(
          int.parse(hexColor.replaceFirst('#', '0xFF').replaceAll(' ', '')));
    } catch (e) {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _parseColor(item.textColor);
    final content = Row(
      children: [
        if (item.icon != null) ...[
          Icon(
            _getIcon(item.icon!),
            color: textColor,
            size: 18,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          item.text,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ],
    );

    if (settings.allowClick && item.link != null) {
      return InkWell(
        onTap: () {
          // Navigate to link (implement based on your router)
          // Navigator.pushNamed(context, item.link!);
        },
        child: content,
      );
    }

    return content;
  }

  IconData _getIcon(String name) {
    final iconMap = {
      'warning': Icons.warning_amber,
      'info': Icons.info_outline,
      'check': Icons.check_circle_outline,
      'star': Icons.star,
      'flash': Icons.flash_on,
    };
    return iconMap[name] ?? Icons.circle;
  }
}
