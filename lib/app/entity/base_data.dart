
class BaseData {
  int currentPage;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;

  @override
  String toString() {
    return 'BaseData{currentPage: $currentPage, offset: $offset, over: $over, pageCount: $pageCount, size: $size, total: $total}';
  }


}