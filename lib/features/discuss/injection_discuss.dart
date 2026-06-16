import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:edutest/features/discuss/data/datasources/discussion_remote_datasource.dart';
import 'package:edutest/features/discuss/data/repositories/discussion_repository_impl.dart';
import 'package:edutest/features/discuss/domain/repositories/discussion_repository.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_detail_bloc.dart';
import 'package:edutest/features/discuss/presentation/bloc/discussion_list_bloc.dart';

Future<void> initDiscuss() async {
  final sl = GetIt.instance;

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  
  sl.registerLazySingleton<Uuid>(() => const Uuid());

  sl.registerLazySingleton<DiscussionRemoteDatasource>(
    () => DiscussionRemoteDatasource(firestore: sl()),
  );

  sl.registerLazySingleton<DiscussionRepository>(
    () => DiscussionRepositoryImpl(
      remoteDatasource: sl(),
      uuid: sl(),
    ),
  );

  sl.registerFactory<DiscussionListBloc>(
    () => DiscussionListBloc(repository: sl()),
  );

  sl.registerFactory<DiscussionDetailBloc>(
    () => DiscussionDetailBloc(repository: sl()),
  );
}
