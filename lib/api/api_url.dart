class ApiURLs {
  static const _baseUrl = "https://palmail.betweenltd.com/api";

  static const login = '$_baseUrl/login';
  static const signup = '$_baseUrl/register';

  static const allStatus = '$_baseUrl/statuses?mail=false';
  static const allTags = '$_baseUrl/tags';
  static const allMails = '$_baseUrl/mails';

  static const createMail = '$_baseUrl/mails';
  static const deleteMail = '$_baseUrl/mails';

  static const allCategories = '$_baseUrl/categories';

  static const getUser = '$_baseUrl/user';
  static const logout = '$_baseUrl/logout';

}
