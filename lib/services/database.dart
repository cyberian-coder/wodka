import 'package:meta/meta.dart';
import 'package:wodka/app/home/models/entry.dart';
import 'package:wodka/app/home/models/wod.dart';
import 'package:wodka/services/api_path.dart';
import 'package:wodka/services/firestore_service.dart';

abstract class Database {
  Future<void> setWod(Wod wod);
  Future<void> deleteWod(Wod wod);
  Stream<Wod> wodStream({@required String wodId});
  Stream<List<Wod>> wodsStream();
  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Wod wod});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setWod(Wod wod) => _service.setData(
        path: APIPath.wod(uid, wod.id),
        data: wod.toMap(),
      );

  @override
  Future<void> deleteWod(Wod wod) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(wod: wod).first;
    for (Entry entry in allEntries) {
      if (entry.wodId == wod.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: APIPath.wod(uid, wod.id));
  }

  @override
  Stream<Wod> wodStream({@required String wodId}) => _service.documentStream(
        path: APIPath.wod(uid, wodId),
        builder: (data, documentId) => Wod.fromMap(data, documentId),
      );

  @override
  Stream<List<Wod>> wodsStream() => _service.collectionStream(
        path: APIPath.wods(uid),
        builder: (data, documentId) => Wod.fromMap(data, documentId),
      );

  @override
  Future<void> setEntry(Entry entry) => _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) => _service.deleteData(
        path: APIPath.entry(uid, entry.id),
      );

  @override
  Stream<List<Entry>> entriesStream({Wod wod}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: wod != null
            ? (query) => query.where('wodId', isEqualTo: wod.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );
}
