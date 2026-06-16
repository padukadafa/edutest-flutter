import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edutest/core/themes/app_colors.dart';
import 'package:edutest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_detail_bloc.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_event.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_state.dart';
import 'package:edutest/features/discuss/presentation/widgets/discussion_reply_item.dart';
import 'package:edutest/features/discuss/presentation/widgets/reply_input.dart';

class DiscussionDetailPage extends StatefulWidget {
  final String discussionId;

  const DiscussionDetailPage({
    super.key,
    required this.discussionId,
  });

  @override
  State<DiscussionDetailPage> createState() => _DiscussionDetailPageState();
}

class _DiscussionDetailPageState extends State<DiscussionDetailPage> {
  String? _replyToId;
  String? _replyToName;

  @override
  void initState() {
    super.initState();
    context.read<DiscussionDetailBloc>().add(LoadDiscussionDetail(widget.discussionId));
    context.read<DiscussionDetailBloc>().add(LoadReplies(widget.discussionId));
  }

  void _handleReply(String content) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthSuccess) return;

    context.read<DiscussionDetailBloc>().add(
      CreateReply(
        discussionId: widget.discussionId,
        authorId: authState.userId,
        authorName: authState.userName,
        authorPhotoUrl: authState.userPhotoUrl,
        content: content,
        parentId: _replyToId,
      ),
    );

    setState(() {
      _replyToId = null;
      _replyToName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussion'),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: BlocListener<DiscussionDetailBloc, DiscussionState>(
        listener: (context, state) {
          if (state is ReplyCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Reply posted')),
            );
          } else if (state is DiscussionActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<DiscussionDetailBloc, DiscussionState>(
                      buildWhen: (previous, current) =>
                          current is DiscussionDetailLoading ||
                          current is DiscussionDetailLoaded ||
                          current is DiscussionError,
                      builder: (context, state) {
                        if (state is DiscussionDetailLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (state is DiscussionDetailLoaded) {
                          final discussion = state.discussion;
                          final authState = context.read<AuthBloc>().state;
                          final userId = authState is AuthSuccess ? authState.userId : '';

                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: AppColors.primary.withOpacity(0.1),
                                      backgroundImage: discussion.authorPhotoUrl != null
                                          ? NetworkImage(discussion.authorPhotoUrl!)
                                          : null,
                                      child: discussion.authorPhotoUrl == null
                                          ? Text(
                                              discussion.authorName[0].toUpperCase(),
                                              style: const TextStyle(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            discussion.authorName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            _formatTime(discussion.createdAt),
                                            style: const TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  discussion.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  discussion.content,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        context.read<DiscussionDetailBloc>().add(
                                          ToggleLikeDiscussion(
                                            discussionId: discussion.id,
                                            userId: userId,
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            discussion.isLikedBy(userId)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: discussion.isLikedBy(userId)
                                                ? Colors.red
                                                : AppColors.textSecondary,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${discussion.likesCount}',
                                            style: TextStyle(
                                              color: discussion.isLikedBy(userId)
                                                  ? Colors.red
                                                  : AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 32),
                                const Text(
                                  'Replies',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if (state is DiscussionError) {
                          return Padding(
                            padding: const EdgeInsets.all(32),
                            child: Center(child: Text(state.message)),
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                    BlocBuilder<DiscussionDetailBloc, DiscussionState>(
                      buildWhen: (previous, current) =>
                          current is RepliesLoading ||
                          current is RepliesLoaded ||
                          current is DiscussionError,
                      builder: (context, state) {
                        if (state is RepliesLoading) {
                          return const Padding(
                            padding: EdgeInsets.all(32),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (state is RepliesLoaded) {
                          if (state.replies.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(32),
                              child: Center(
                                child: Text(
                                  'No replies yet',
                                  style: TextStyle(color: AppColors.textSecondary),
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.replies.length,
                            itemBuilder: (context, index) {
                              final reply = state.replies[index];
                              final authState = context.read<AuthBloc>().state;
                              final userId = authState is AuthSuccess ? authState.userId : '';

                              return DiscussionReplyItem(
                                reply: reply,
                                isLiked: reply.isLikedBy(userId),
                                onLike: () {
                                  context.read<DiscussionDetailBloc>().add(
                                    ToggleLikeReply(
                                      discussionId: widget.discussionId,
                                      replyId: reply.id,
                                      userId: userId,
                                    ),
                                  );
                                },
                                onReply: (replyId, authorName) {
                                  setState(() {
                                    _replyToId = replyId;
                                    _replyToName = authorName;
                                  });
                                },
                                showReplyToIndicator: true,
                              );
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
            ),
            ReplyInput(
              onSend: _handleReply,
              replyTo: _replyToName,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${time.day}/${time.month}/${time.year}';
  }
}
