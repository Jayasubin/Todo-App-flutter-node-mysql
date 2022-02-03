import '../view/completed/completed.dart';
import '../view/pending/pending.dart';

const activePageID = Pending.pageID;
const completedPageID = Completed.pageID;

final routes = {
  activePageID: (context) => const Pending(),
  completedPageID: (context) => const Completed(),
};
