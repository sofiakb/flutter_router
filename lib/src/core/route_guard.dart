import 'dart:developer';

class RouteGuard {
  String from;
  String to;
  String Function()? onSuccess;
  String Function()? onError;

  RouteGuard({
    required this.from,
    required this.to,
    required this.onSuccess,
    required this.onError,
  });

  Future<bool> handle(context) async {
    return true;
  }

  String handleSuccess() {
    log('success');
    log(to);
    return onSuccess == null ? to : onSuccess!();
  }

  String handleError() {
    log('error');
    log(from);
    return onError == null ? from : onError!();
  }
}