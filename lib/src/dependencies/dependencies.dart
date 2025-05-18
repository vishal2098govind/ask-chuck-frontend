import 'package:ask_chuck/src/features/chat/data/chat_repository.dart';
import 'package:ask_chuck/src/features/interactive_avatar/data/heygen_repo.dart';
import 'package:ask_chuck/src/features/interactive_avatar/data/heygen_repo_impl.dart';
import 'package:get_it/get_it.dart';

class Dependencies {
  static final _getIt = GetIt.instance;

  static void initDependencies() {
    _getIt.registerSingleton<ChatRepository>(ChatRepository());
    _getIt.registerSingleton<HeygenRepo>(HeygenRepoImpl());
  }
}

ChatRepository get chatRepository => Dependencies._getIt.get();

HeygenRepo get heygenRepo => Dependencies._getIt.get();
