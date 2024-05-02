abstract class IBaseDb {
  Future<void> connectDb();
  Future<void> closeDb();
  Future<void> createCollectionOrTable();
}
