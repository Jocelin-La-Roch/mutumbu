// @dart=2.9

class ServiceResponse<T>{
  T data;
  bool error;
  String errorMessage;
  bool permissionGranted;

  ServiceResponse({this.data, this.error=true, this.errorMessage, this.permissionGranted=true});
}