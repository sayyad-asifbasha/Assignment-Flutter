class ApiUrl {
  static const baseUrl = "https://api.restful-api.dev/objects";

  // GET
  static String allObjects() =>baseUrl;

  static String listByIds(List<String> ids) {
    final query = ids.map((id) => "id=$id").join("&");
    return "$baseUrl?$query";
  }

  static String singleObject(String id) => "$baseUrl/$id";

  // POST
  static String addObject() => baseUrl;

  // PUT
  static String updateObject(String id) => "$baseUrl/$id";

  // PATCH
  static String partialUpdateObject(String id) => "$baseUrl/$id";

  // DELETE
  static String deleteObject(String id) => "$baseUrl/$id";
}
