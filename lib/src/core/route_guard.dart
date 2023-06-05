class RouteGuard {
  String? from;
  String? to;
  void Function()? onSuccess;
  void Function()? onError;

  RouteGuard({
    this.from,
    this.to,
    this.onSuccess,
    this.onError,
  });

  Future<bool> handle(context) async {
    return true;
  }
}
