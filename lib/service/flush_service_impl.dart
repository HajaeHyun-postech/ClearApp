import 'package:bot_toast/bot_toast.dart';
import 'package:clearApp/service/flush_service.dart';

class FlushServiceImpl implements FlushService {
  @override
  void errorToast(String msg) {
    BotToast.showText(text: msg);
  }

  @override
  void infoToast(String msg) {
    BotToast.showText(text: msg);
  }

  @override
  void successToast(String msg) {
    BotToast.showText(text: msg);
  }
}
