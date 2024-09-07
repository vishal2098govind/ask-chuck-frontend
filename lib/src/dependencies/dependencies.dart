import 'package:ask_chuck/src/features/chat/data/chat_repository.dart';
import 'package:get_it/get_it.dart';

class Dependencies {
  static final _getIt = GetIt.instance;

  static void initDependencies() {
    _getIt.registerSingleton<ChatRepository>(ChatRepository());
  }
}

ChatRepository get chatRepository => Dependencies._getIt.get();
