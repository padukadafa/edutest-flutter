import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:edutest/core/themes/app_colors.dart';
import 'package:edutest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_detail_bloc.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_list_bloc.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_event.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_state.dart';
import 'package:edutest/features/discuss/presentation/pages/create_discussion_page.dart';
import 'package:edutest/features/discuss/presentation/pages/discussion_detail_page.dart';
import 'package:edutest/features/discuss/presentation/widgets/discussion_card.dart';
import 'package:edutest/injection/injection_container.dart';

class DiscussPage extends StatelessWidget {
  const DiscussPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussions'),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: BlocListener<DiscussionListBloc, DiscussionState>(
        listener: (context, state) {
          if (state is DiscussionActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<DiscussionListBloc, DiscussionState>(
          buildWhen: (previous, current) => current is! DiscussionCreated,
          builder: (context, state) {
            if (state is DiscussionsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            
            if (state is DiscussionsLoaded) {
              if (state.discussions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/none_konten.png', width: 220),
                      const SizedBox(height: 24),
                      const Text(
                        'No Discussion Yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Start a discussion to connect\nwith others',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<DiscussionListBloc>().add(LoadDiscussions());
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: state.discussions.length,
                  itemBuilder: (context, index) {
                    final discussion = state.discussions[index];
                    final authState = context.read<AuthBloc>().state;
                    final userId = authState is AuthSuccess ? authState.userId : '';
                    final isOwner = discussion.authorId == userId;
                    
                    return DiscussionCard(
                      discussion: discussion,
                      isLiked: discussion.isLikedBy(userId),
                      isOwner: isOwner,
                      onLike: () {
                        context.read<DiscussionListBloc>().add(
                          ToggleLikeDiscussion(
                            discussionId: discussion.id,
                            userId: userId,
                          ),
                        );
                      },
                      onDelete: isOwner
                          ? () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Delete Discussion'),
                                  content: const Text('Are you sure you want to delete this discussion? This action cannot be undone.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(dialogContext),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(dialogContext);
                                        context.read<DiscussionListBloc>().add(
                                          DeleteDiscussion(
                                            discussionId: discussion.id,
                                            userId: userId,
                                          ),
                                        );
                                      },
                                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            }
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => sl<DiscussionDetailBloc>(),
                              child: DiscussionDetailPage(
                                discussionId: discussion.id,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }

            if (state is DiscussionError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<DiscussionListBloc>().add(LoadDiscussions());
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<DiscussionListBloc>(),
                child: const CreateDiscussionPage(),
              ),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}
