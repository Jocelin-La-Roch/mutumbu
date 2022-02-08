class ServiceResponse<T>{
  T data;
  bool error;
  String errorMessage;
  bool permissionGranted;

  ServiceResponse({required this.data, this.error=true, required this.errorMessage, this.permissionGranted=true});
}