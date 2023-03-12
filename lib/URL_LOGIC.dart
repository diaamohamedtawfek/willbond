
class URL_LOGIC {

  //
  // static String api2="http://196.221.151.69:8085/zad-wellbond-backend/"; // server user
  static String api2="https://zad-solutions.com/api-wellbond/"; // server
  // static String api2="https://zad-solutions.com/api-wellbond/"; // server user


  static String refrechToken=api2+"auth/refresh-token";

  static String login=api2+"auth/sign-in";
  static String signUp=api2+"auth/sign-up";
  static String token_firebase_send=api2+"security-user/set-user-device-token";
  static String getInfo_dataUser=api2+"security-user/get-logged-in-info-user";


  static String uplodeImage = api2 + "security-user/upload-profile-image?fileName=";

  static String  change_password=api2+"auth/change-password";


  static String notification=api2+"notification-mobile/get-notification-logged-in-user";

  static String   update_profile=api2+"security-user/update";

  static String listItem_Home="${api2}items-mobile/list?page=0&size=4";

  static String new_listItem_news_Home="${api2}items-mobile/list-new-item?page=0&size=4";

  static String new_listItem_news_AllList="${api2}items-mobile/list-new-item?page=";

  static String listAllItem="${api2}items-mobile/list?page=";

  static String find_by_id="${api2}items-mobile/find?id=";

  static String favorite="${api2}item-favorite-mobile/new";
  static String Un_favorite_page_favorite="${api2}item-favorite-mobile/un-favourite-items";
  static String Un_favorite="${api2}item-favorite-mobile/delete-item-favourite?itemId=";

  static String getAll_favorite="${api2}item-favorite-mobile/get-favorite-item-for-login-user?page=";

  static String getAll_branch="${api2}branch-lookup/list?page=0&size=1000";


  //send order
  static String send_order="${api2}order-mobile/submit-order";
  static String resend_order="${api2}order-mobile/re-submit-order";
  static String close_order="${api2}order-mobile/close-order";


  static String running_orders_trackOrder="${api2}order-mobile/customer/get-running-orders?page=";
  static String draft_orders_trackOrder="${api2}order-mobile/customer/get-draft-orders?page=";
  static String get_completed_orders="${api2}order-mobile/customer/get-completed-orders?page=";

  static String get_item_order_finch="${api2}order-mobile/find?id=";

  static String serch_home="${api2}items-mobile/get-item-by-color-code-or-desc-lov?searchKey=";

  static String sind_Fillter="${api2}order-mobile/filter-customer-order?orderTotalFrom=10&orderTotalTo=10000&submitDateFrom=2020-08-09&submitDateTo=2020-09-10&page=0&size=15";


}