import 'package:flutter/material.dart';
import 'package:edutest/core/themes/app_colors.dart';
import 'package:edutest/features/discuss/domain/entities/discussion_reply.dart';

class DiscussionReplyItem extends StatelessWidget {
  final DiscussionReply reply;
  final VoidCallback onLike;
  final bool isLiked;
  final Function(String replyId, String authorName)? onReply;
  final bool showReplyToIndicator;

  const DiscussionReplyItem({
    super.key,
    required this.reply,
    required this.onLike,
    required this.isLiked,
    this.onReply,
    this.showReplyToIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16 + (reply.isReply ? 24 : 0),
        right: 16,
        top: 8,
        bottom: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reply.isReply)
            Container(
              width: 2,
              height: 24,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.secondary.withOpacity(0.1),
            backgroundImage: reply.authorPhotoUrl != null
                ? NetworkImage(reply.authorPhotoUrl!)
                : null,
            child: reply.authorPhotoUrl == null
                ? Text(
                    reply.authorName[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (reply.isReply)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.reply,
                                size: 10,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Reply',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Text(
                        reply.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(reply.createdAt),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reply.content,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: onLike,
                        child: Row(
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 16,
                              color: isLiked ? Colors.red : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${reply.likesCount}',
                              style: TextStyle(
                                color: isLiked ? Colors.red : AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (onReply != null) ...[
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () => onReply?.call(reply.id, reply.authorName),
                          child: const Text(
                            'Reply',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    return '${difference.inDays}d';
  }
}
