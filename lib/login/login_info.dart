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
  bool isAdmin;

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

  bool getIsAdmin() {
    return isAdmin;
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

  LoginInfo setIsAdmin(String _isAdmin) {
    if (_isAdmin == '1')
      isAdmin = true;
    else
      isAdmin = false;
  }
}
