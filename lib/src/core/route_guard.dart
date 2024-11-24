class RouteGuard {
  void Function()? onSuccess;
  void Function()? onError;
  String redirectTo;

  RouteGuard({
    required this.onSuccess,
    required this.onError,
    this.redirectTo = '/',
  });

  Future<bool> handle(context) async {
    const isAllowed = true;
    if (!isAllowed) {
      this.handleError();
      return false;
    }
    this.handleSuccess();
    return true;
  }

  void handleSuccess() {
    return onSuccess == null ? null : onSuccess!();
  }

  void handleError() {
    return onError == null ? null : onError!();
  }
}
