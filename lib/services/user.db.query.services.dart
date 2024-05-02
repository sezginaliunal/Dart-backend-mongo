abstract class IUserQueryServices {
  Future<void> deleteOne(String id);
  Future<void> updateOne(String id, String field, dynamic data);
}
