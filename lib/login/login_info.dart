/*
 * Class : LoginInfo
 * Description : Holding povisId & student id, using singeton pattern
 * Example code :
 * LoginInfo().getName() == LoginInfo().getName() //true 
 */

class LoginInfo {
  static final LoginInfo _loginInfo = LoginInfo._internal();
  String name;
  String povisId;
  String studentId;

  factory LoginInfo() {
    return _loginInfo;
  }

  LoginInfo._internal();

  String getName() {
    return name;
  }

  String getPovisId() {
    return povisId;
  }

  String getStudentId() {
    return studentId;
  }

  LoginInfo setName(String _name) {
    name = _name;
    return this;
  }

  LoginInfo setPovisId(String _povisId) {
    povisId = _povisId;
    return this;
  }

  LoginInfo setStudentId(String _studentId) {
    studentId = _studentId;
    return this;
  }
}
