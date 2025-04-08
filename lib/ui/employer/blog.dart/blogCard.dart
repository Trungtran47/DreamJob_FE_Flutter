import 'package:dacn2/data/models/blog.dart';
import 'package:dacn2/data/services/blog_service.dart';
import 'package:dacn2/data/util/Util.dart';
import 'package:dacn2/ui/employer/blog.dart/blogDetail.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final VoidCallback? onLike;
  final VoidCallback? onShare;
  final VoidCallback? onReadMore;
  final VoidCallback onDelete;
  final VoidCallback onUpdate;

  const BlogCard({
    Key? key,
    required this.blog,
    this.onLike,
    this.onShare,
    this.onReadMore,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BlogDetail(blog: blog)),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildImage(),
            _buildContent(context),
            const Divider(height: 1, color: Colors.grey),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: blog.image != null
          ? Image.network(
              blog.imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 150,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 150,
                  alignment: Alignment.center,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.broken_image, size: 50),
                );
              },
            )
          : Container(
              height: 150,
              color: Colors.grey.shade300,
              child: const Icon(Icons.image, size: 50, color: Colors.grey),
            ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            blog.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            blog.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade700,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              TextButton.icon(
                onPressed: onShare,
                icon: const Icon(Icons.share, color: Colors.blue),
                label: const Text('Share'),
              ),
              const SizedBox(width: 8),
              Text(
                blog.statusBlog(),
                style: TextStyle(
                  fontSize: 14,
                  color: blog.status == 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          PopupMenuButton<String>(
            color: Colors.white,
            icon: const Icon(Icons.more_vert),
            onSelected: (String result) {
              if (result == 'Sửa') {
                onUpdate();
              } else if (result == 'Xóa') {
                _showDeleteDialog(context);
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'Sửa',
                child: Text('Sửa'),
              ),
              const PopupMenuItem<String>(
                value: 'Xóa',
                child: Text('Xóa'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc muốn xóa bài viết này không?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Không'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Có'),
              onPressed: () {
                if (blog.blogId != null) {
                  BlogService(baseUrl: Util.baseUrl).deleteBlog(blog.blogId!);
                  onDelete();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Đã xóa bài "${blog.title}"'),
                  ));
                } else {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Không thể xóa bài viết này'),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
