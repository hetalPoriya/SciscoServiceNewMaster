import 'package:scisco_service/models/getCustomer.dart';

String BASE_URL = "https://sciscohealthineer.com/service/admin/";
// https://synramtechnology.com/service/admin/Api/customer_login
String ASSET_URL = "https://sciscohealthineer.com/service/admin/";
String loginapi = "Api/login";
String reqpasswordapi = "Api/forgot_password";
String allocatedlist = "Api/view_allocated_products";
String sendnowurl = "Api/create_service_request";
String editprofile = "Api/customer_details";
String edit_profileUrl = "Api/update_customer";
String preinstallation = "Api/fill_pre_installation_form";
String installationform = "Api/fill_installation_form";
String installationrequests = "Api/view_installation_requests";
String servicerequest = "Api/view_service_requests";
String clickserviceresponse = "Api/service_response";
String onserviceform = "Api/custom_service_fields";
String onwebserviceform = "Api/get_service_form";
String onsubmitserviceform = "Api/fill_service_form";
String getEngineerHomescreenCount = "Api/get_engineer_homescreen_count";
String customerchangepassword = "Api/update_customer_password";
String serviceengineerdetails = "Api/service_engineer_details";
String updateengineer = "Api/update_engineer";
String productdetail = "Api/view_allocated_product_details";
String insdetail = "Api/view_installation_request_details";
String serreqdetail = "Api/view_service_request_details";
String insreqpending = "Api/installation_requests";
String insreqdone = "Api/installation_done";
String servicereqdone = "Api/service_done";
String servicereqpending = "Api/service_requests";
String engineerLocationUrl = "Api/engineer_location"; //punch in api
String oncustomerlist = "api/get_customers";
String onProductList = "api/get_products";
String markin_reason = "api/mark_in_reasons";
bool markin = false;
bool markout = false;
double mapLatitude, mapLongitude;
double lastMapLatitude, lastMapLongitude;
List<String> customerList = [];
List<Customerss> newCustomerList = [];

class SharedPrefKey {
  static String ISLOGEDIN = "ISLOGEDIN";
  // static String ISPUNCHEDIN = "ISLOGEDIN";
  static String ISPUNCHEDIN = "ISPUNCHEDIN"; //punch in = 1 , punch out = 0
  static String COSTUMERID = "COSTUMERID";
  static String ENGINEER_STATUS = "ENGINEER_STATUS";
  static String ENGINEER_NAME = "ENGINEER_NAME";
  static String ENGINEER_EMAIL = "ENGINEER_EMAIL";
  static String ENGINEER_MOBILE = "ENGINEER_MOBILE";
  static String SERVICEENGINEERID = "SERVICEENGINEERID";
  static String CUSTOMERNAME = "CUSTOMERNAME";
  static String SERVICEENGINEERNAME = "SERVICEENGINEERNAME";
  static String INSTALLATIONPENDING = "INSTALLATIONPENDING";
  static String INSTALLATIONDONE = "INSTALLATIONDONE";
  static String SERVICEPENDING = "SERVICEPENDING";
  static String SERVICEDONE = "SERVICEDONE";
  static String EMAILID = "EMAILID";
  static String MOBILENO = "MOBILENO";
  static String WHATSAPP = "WHATSAPPNO";
  static String ADDRESS = "ADDRESS";
  static String ORGANIZATION = "ORGANIZATION";
  static String MARK_IN_REASON = "MARK_IN_REASON";
  static String SELECTED_CUSTOMER = "SELECTED_CUSTOMER";
  static String PRODUCTID = "PRODUCTID";
  static String IS_MARKED_IN = "IS_MARKED_IN";
  static String MARKER_COUNTS = "MARKER_COUNTS";
  static String ASSIGNEDPRODUCTID = "ASSIGNEDPRODUCTID";
  static String SERVICEREASON = "SERVICEREASON";
  static String SERVICEREQID = "SERVICEREQID";
}

class ShardPrefReg {
  static String FIRSTNAMEREG = "FIRSTNAMEREG";
  static String LASTNAMEREG = "LASTNAMEREG";
  static String MOBILEREG = "MOBILEREG";
  static String EMAILREG = "EMAILREG";
  static String ADDRESSREG = "ADDRESSREG";
  static String SUBURBREG = "SUBURBREG";
  static String POSTCODEREG = "POSTCODEREG";
  static String DOBREG = "DOBREG";
  static String PASSWORDREG = "PASSWORDREG";
  static String PROFILEIMGREG = "PROFILEIMGREG";
  static String DLFRONT = "DLFRONT";
  static String DLBACK = "DLBACK";
  static String VRPIMG = "VRPIMG";
  static String PLIIMAGE = "PLIIMAGE";
}
