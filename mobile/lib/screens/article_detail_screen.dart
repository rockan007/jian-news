import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({
    Key? key,
    required this.article,
  }) : super(key: key);

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _shareArticle(BuildContext context) {
    Share.share(
      '${article.title}\n\nRead more: ${article.url}',
      subject: article.title,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');
    DateTime? publishedDate;
    
    try {
      publishedDate = DateTime.parse(article.publishedAt);
    } catch (e) {
      publishedDate = null;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.source.name,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareArticle(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured image
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: article.urlToImage!,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 250,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
              ),
              
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    article.title,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Author and date
                  Row(
                    children: [
                      if (article.author != null && article.author!.isNotEmpty)
                        Expanded(
                          child: Text(
                            'By ${article.author}',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (publishedDate != null)
                        Text(
                          dateFormat.format(publishedDate),
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  if (article.description != null && article.description!.isNotEmpty)
                    Text(
                      article.description!,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                  const SizedBox(height: 16),
                  
                  // Content
                  if (article.content != null && article.content!.isNotEmpty)
                    Text(
                      article.content!.replaceAll(RegExp(r'\[\+\d+ chars\]$'), ''),
                      style: textTheme.bodyMedium,
                    ),
                    
                  const SizedBox(height: 24),
                  
                  // Read more button
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => _launchUrl(article.url),
                      icon: const Icon(Icons.launch),
                      label: const Text('Read Full Article'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
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
} 