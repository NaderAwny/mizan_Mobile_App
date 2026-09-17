class Failure {
  // 200 or 400 or 500 or -1 for no internet or -2 for server error or -3 for unknown error
  final int code;
  // error message from server and for no internet and for server error and for unknown error
  final String message;
  Failure(this.code, this.message);
}

