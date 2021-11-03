import 'package:ali_poster/data/model/worker.dart';
import 'package:firebase_database/firebase_database.dart';

class WorkerDao {
  final _workerReference =
      FirebaseDatabase.instance.reference().child('workers');

  void saveMessage(Worker worker) {
    _workerReference.push().set(worker.toJson());
  }

  void updateWorker(Worker worker) {
    _workerReference.update({worker.id.toString(): worker.toJson()});
  }

  Query getWorker() {
    return _workerReference;
  }
}
