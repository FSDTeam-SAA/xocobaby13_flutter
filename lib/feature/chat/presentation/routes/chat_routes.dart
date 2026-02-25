import 'package:go_router/go_router.dart';
import 'package:xocobaby13/feature/chat/model/chat_sample_data.dart';
import 'package:xocobaby13/feature/chat/model/chat_thread_model.dart';
import 'package:xocobaby13/feature/chat/presentation/screen/chat_detail_screen.dart';

class ChatRouteNames {
  const ChatRouteNames._();

  static const String detail = '/chat/detail';
}

class ChatRoutes {
  const ChatRoutes._();

  static final List<RouteBase> routes = <RouteBase>[
    GoRoute(
      path: ChatRouteNames.detail,
      builder: (_, GoRouterState state) {
        final ChatThreadModel thread = state.extra is ChatThreadModel
            ? state.extra! as ChatThreadModel
            : ChatSampleData.defaultThread();
        return ChatDetailScreen(thread: thread);
      },
    ),
  ];
}
