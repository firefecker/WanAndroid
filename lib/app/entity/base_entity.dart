
class BaseEntity {
  int errorCode;
  String errorMsg;

  @override
  String toString() {
    return 'BaseEntity{errorCode: $errorCode, errorMsg: $errorMsg}';
  }


}