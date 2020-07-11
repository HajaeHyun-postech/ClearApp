/*
 * Class : LoginInfo
 * Description : Holding name & student id, using singeton pattern
 * Example code :
 * LoginInfo().getName() == LoginInfo().getName() //true 
 */

class LoginInfo {
  static final LoginInfo _loginInfo = LoginInfo._internal();
  String name;
  String studentId;

  factory LoginInfo() {
    return _loginInfo;
  }

  LoginInfo._internal();

  String getName() {
    return name;
  }

  String getStudentId() {
    return studentId;
  }

  LoginInfo setName(String _name) {
    name = _name;
    return this;
  }

  LoginInfo setStudentId(String _studentId) {
    studentId = _studentId;
    return this;
  }
}
