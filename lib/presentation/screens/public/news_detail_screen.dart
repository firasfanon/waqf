import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/models/news_article.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../providers/news_provider.dart';

class NewsDetailScreen extends ConsumerStatefulWidget {
  const NewsDetailScreen({super.key, this.article});

  final NewsArticle? article;

  @override
  ConsumerState<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends ConsumerState<NewsDetailScreen> {
  late ScrollController _scrollController;
  bool _isAppBarCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    // Increment view count
    if (widget.article != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Increment view count in the service
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    const offset = 200;
    if (_scrollController.offset > offset && !_isAppBarCollapsed) {
      setState(() => _isAppBarCollapsed = true);
    } else if (_scrollController.offset <= offset && _isAppBarCollapsed) {
      setState(() => _isAppBarCollapsed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.article == null) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'خبر غير موجود'),
        body: _buildErrorState(),
      );
    }

    final article = widget.article!;

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Custom App Bar with Image
          SliverAppBar(
            expandedHeight: 300.0,
            floating: false,
            pinned: true,
            backgroundColor: AppConstants.islamicGreen,
            flexibleSpace: FlexibleSpaceBar(
              title: _isAppBarCollapsed
                  ? Text(
                article.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Colors.black45,
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
                  : null,
              background: _buildHeroImage(article),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _shareArticle(article),
              ),
              IconButton(
                icon: const Icon(Icons.bookmark_border),
                onPressed: () => _bookmarkArticle(article),
              ),
            ],
          ),

          // Article Content
          SliverToBoxAdapter(
            child: _buildArticleContent(article),
          ),

          // Related Articles
          SliverToBoxAdapter(
            child: _buildRelatedArticles(article),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(NewsArticle article) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        article.imageUrl != null
            ? CachedNetworkImage(
          imageUrl: article.imageUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: AppConstants.islamicGreen,
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            decoration: const BoxDecoration(
              gradient: AppConstants.islamicGradient,
            ),
            child: const Center(
              child: Icon(Icons.article, size: 100, color: Colors.white),
            ),
          ),
        )
            : Container(
          decoration: const BoxDecoration(
            gradient: AppConstants.islamicGradient,
          ),
          child: const Center(
            child: Icon(Icons.article, size: 100, color: Colors.white),
          ),
        ),

        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),

        // Article Meta Information
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.islamicGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  article.category.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Title
              if (!_isAppBarCollapsed)
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      const Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Colors.black45,
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 8),

              // Meta Info
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    article.author,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.access_time, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    AppDateUtils.formatArabicDate(article.publishedAt ?? article.createdAt),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const Spacer(),
                  const Icon(Icons.visibility, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${article.viewCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArticleContent(NewsArticle article) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Excerpt
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppConstants.paddingL),
            decoration: BoxDecoration(
              color: AppConstants.islamicGreen.withOpacity(0.05),
              border: const Border(
                right: BorderSide(
                  color: AppConstants.islamicGreen,
                  width: 4,
                ),
              ),
            ),
            child: Text(
              article.excerpt,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: AppConstants.islamicGreen,
                height: 1.6,
              ),
            ),
          ),

          // Article Content
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content
                Text(
                  article.content,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.8,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 24),

                // Tags
                if (article.tags.isNotEmpty) ...[
                  Text(
                    'العلامات:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.islamicGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: article.tags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: AppConstants.islamicGreen.withOpacity(0.1),
                        side: BorderSide(color: AppConstants.islamicGreen.withOpacity(0.3)),
                        labelStyle: const TextStyle(
                          color: AppConstants.islamicGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _shareArticle(article),
                        icon: const Icon(Icons.share),
                        label: const Text('مشاركة'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConstants.islamicGreen,
                          side: const BorderSide(color: AppConstants.islamicGreen),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _bookmarkArticle(article),
                        icon: const Icon(Icons.bookmark),
                        label: const Text('حفظ'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.islamicGreen,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedArticles(NewsArticle article) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أخبار ذات صلة',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.islamicGreen,
            ),
          ),
          const SizedBox(height: 16),
          Consumer(
            builder: (context, ref, child) {
              final relatedArticlesAsync = ref.watch(newsByCategoryProvider(article.category));

              return relatedArticlesAsync.when(
                data: (articles) {
                  final relatedArticles = articles
                      .where((a) => a.id != article.id)
                      .take(3)
                      .toList();

                  if (relatedArticles.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: relatedArticles.map((relatedArticle) {
                      return _buildRelatedArticleCard(relatedArticle);
                    }).toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedArticleCard(NewsArticle article) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(article: article),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
              child: SizedBox(
                width: 60,
                height: 60,
                child: article.imageUrl != null
                    ? CachedNetworkImage(
                  imageUrl: article.imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.article),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.article),
                  ),
                )
                    : Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.article),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppDateUtils.getTimeAgo(article.publishedAt ?? article.createdAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'الخبر غير موجود',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على هذا الخبر',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('العودة'),
          ),
        ],
      ),
    );
  }

  void _shareArticle(NewsArticle article) {
    Share.share(
      '${article.title}\n\n${article.excerpt}\n\nوزارة الأوقاف والشؤون الدينية الفلسطينية',
      subject: article.title,
    );
  }

  void _bookmarkArticle(NewsArticle article) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حفظ الخبر بنجاح'),
        backgroundColor: AppConstants.islamicGreen,
        action: SnackBarAction(
          label: 'تراجع',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}