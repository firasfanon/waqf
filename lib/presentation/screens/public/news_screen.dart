import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/news_article.dart';
import '../../../app/router.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/news/news_card.dart';
import '../../widgets/common/loading_widget.dart';
import '../../providers/news_provider.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({super.key});

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  bool _isGridView = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: 'الأخبار',
        showSearchButton: true,
        showNotificationButton: true,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
            tooltip: _isGridView ? 'عرض قائمة' : 'عرض شبكي',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            color: Colors.grey[50],
            child: TextField(
              onChanged: (value) {
                setState(() => _searchQuery = value);
                ref.read(newsFilterProvider.notifier).setSearchQuery(value);
              },
              textDirection: TextDirection.rtl,
              decoration: InputDecoration(
                hintText: 'البحث في الأخبار...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Tab Bar for Categories
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: AppColors.islamicGreen,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.islamicGreen,
              tabs: const [
                Tab(text: 'الكل'),
                Tab(text: 'أخبار مميزة'),
                Tab(text: 'أحدث الأخبار'),
              ],
            ),
          ),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAllNews(),
                _buildFeaturedNews(),
                _buildLatestNews(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllNews() {
    return Consumer(
      builder: (context, ref, child) {
        final newsAsync = ref.watch(filteredNewsProvider);

        return newsAsync.when(
          data: (articles) => _buildNewsList(articles),
          loading: () => const Center(child: LoadingWidget(message: 'جاري تحميل الأخبار...')),
          error: (error, stack) => _buildErrorState(error.toString()),
        );
      },
    );
  }

  Widget _buildFeaturedNews() {
    return Consumer(
      builder: (context, ref, child) {
        final newsAsync = ref.watch(featuredNewsProvider);

        return newsAsync.when(
          data: (articles) => _buildNewsList(articles),
          loading: () => const Center(child: LoadingWidget(message: 'جاري تحميل الأخبار المميزة...')),
          error: (error, stack) => _buildErrorState(error.toString()),
        );
      },
    );
  }

  Widget _buildLatestNews() {
    return Consumer(
      builder: (context, ref, child) {
        final newsAsync = ref.watch(latestNewsProvider);

        return newsAsync.when(
          data: (articles) => _buildNewsList(articles),
          loading: () => const Center(child: LoadingWidget(message: 'جاري تحميل آخر الأخبار...')),
          error: (error, stack) => _buildErrorState(error.toString()),
        );
      },
    );
  }

  Widget _buildNewsList(List<NewsArticle> articles) {
    if (articles.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(newsProvider);
        ref.invalidate(featuredNewsProvider);
        ref.invalidate(latestNewsProvider);
      },
      child: _isGridView ? _buildGridView(articles) : _buildListView(articles),
    );
  }

  Widget _buildGridView(List<NewsArticle> articles) {
    return AnimationLimiter(
      child: GridView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 300),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: NewsCard(
                  article: articles[index],
                  isGridView: true,
                  onTap: () => _navigateToArticle(articles[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(List<NewsArticle> articles) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        itemCount: articles.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 300),
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: NewsCard(
                  article: articles[index],
                  isGridView: false,
                  onTap: () => _navigateToArticle(articles[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد أخبار',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'لم يتم نشر أي أخبار بعد'
                : 'لم يتم العثور على أخبار تطابق البحث',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          if (_searchQuery.isNotEmpty)
            ElevatedButton(
              onPressed: () {
                setState(() => _searchQuery = '');
                ref.read(newsFilterProvider.notifier).clearSearch();
              },
              child: const Text('مسح البحث'),
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'خطأ في تحميل الأخبار',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.red[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(newsProvider);
              ref.invalidate(featuredNewsProvider);
              ref.invalidate(latestNewsProvider);
            },
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  void _navigateToArticle(NewsArticle article) {
    // Add to recently viewed
    ref.read(recentlyViewedNewsProvider.notifier).addArticle(article);

    // Navigate to detail screen
    AppRouter.push(
      context,
      AppRouter.newsDetail,
      arguments: article,
    );
  }
}