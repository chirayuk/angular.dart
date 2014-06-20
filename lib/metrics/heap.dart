part of angular.metrics;

/**
 * Maintain a list of the slowest N items.  Implemented via a min-heap.
 *
 * Heap operations based on Python's heapq module:
 * http://hg.python.org/cpython/file/2.7/Lib/heapq.py
 *
 * Motivation of using a heap:
 * ---------------------------
 * When gathering metrics (e.g. consider dirty checking), we want to keep track
 * of the N slowest operations for some value of N.
 *
 * The number of operations performed (e.g. dirty checks) is >> N.
 *
 * If an operation is faster than all N of the currently recorded slow
 * operations, then we can completely ignore it.  Only when that is not the
 * case do we need to track it and get rid of some other faster operation.
 *
 * A fixed size heap is ideal for this and will avoid most inserts and keep
 * track of the N slowest operations for us.
 *
 * Additionally, until we gather the first N items, it is cheaper to just add
 * append them to the list and only when we have to perform the first
 * remove/replace (i.e. when we reach capacity), convert it into a heap.
 *
 * Additionally, we maintain two heaps with one tracking just the elapsedMicros
 * since that's what's used for the comparisons and we'd like that to be super
 * fast.
 */

// comparator to sort in descending order of time taken.
int _compareMetricRecords(MetricRecord a, MetricRecord b) {
  if (a == null && b == null) {
    return 0;
  } else if (a == null) {
    return 1;
  } else if (b == null) {
    return -1;
  } else {
    return b.microseconds - a.microseconds;
  }
}


// ckck: can now get rid of the _micros list.
class MetricsHeap {
  final int _capacity;
  int _size = 0;
  final List<int> _micros;
  final List<MetricRecord> _records;
  List<MetricRecord> _sortedRecords = null;

  MetricsHeap(int capacity):
      _capacity = capacity,
      _micros = new List<int>(capacity), // fixed size
      _records = new List<MetricRecord>(capacity) { // fixed size
    assert(_capacity >= 0);
  }

  void reset() {
    _size = 0;
    _sortedRecords = null;
  }

  int get length => _size;
  bool get isEmpty => (_size == 0);
  bool get isNotEmpty => (_size != 0);


  // Returns a list of the slowest records in descending order.
  // IMPORTANT: Accessing this getter indicates that you're done with adding
  //     new records.  The heap structure is *destroyed* and further calls to
  //     record() will fail with trying to operate on a null object.
  List<MetricRecord> get sortedRecords {
    if (_sortedRecords == null) {
      _sortedRecords = new List.from(_records.take(_size), growable: false);
      _sortedRecords.sort(_compareMetricRecords);
    }
    return _sortedRecords;
  }

  void storeSortedRecords(List<MetricRecord> records) {
    assert(records.length >= _size);
    records.setAll(0, _records.take(_size));
    records.fillRange(_size, records.length, null);
    records.sort(_compareMetricRecords);
  }

  static _getDetail(dynamic detail) => (detail is Function) ? detail() : detail;

  void record(String tag, dynamic detail, int microseconds) {
    // We could also simply set _sortedRecords to null and be done with it,
    // instead of asserting here.  That would force recalculation of
    // sortedRecords on the next access but I'd like folks to be aware of this
    // cost before doing so.
    _sortedRecords = null; // ckck
    assert(_sortedRecords == null &&
           "Call MetricsHeap::reset() in order to record fresh again." != null);
    if (_size < _capacity) {
      _micros[_size] = microseconds;
      _records[_size] = new MetricRecord(tag, _getDetail(detail), microseconds);
      _size++;
      if (_size + 1 == _capacity) {
        _heapify();
      }
      return;
    }
    int fastestMicros = _micros[0];
    if (microseconds < fastestMicros) {
      return;
    }
    _heapReplace(new MetricRecord(tag, _getDetail(detail), microseconds));
  }

  // _heapReplace is faster than a heap pop followed by a heap push.
  void _heapReplace(MetricRecord record) {
    _records[0] = record;
    _micros[0] = record.microseconds;
    _siftUp(0);
  }

  void _heapify() {
    for (int i = (_size >> 1) - 1; i >= 0; i--) {
      _siftUp(i);
    }
  }

  void _siftUp(int idx) {
    int endIdx = _size;
    int startIdx = idx;
    MetricRecord newRecord = _records[idx];
    // Bubble up the smaller child until hitting a leaf.
    int childIdx = (idx << 1) + 1;
    while (childIdx < endIdx) {
      int rightChildIdx = childIdx + 1;
      if (rightChildIdx < endIdx &&
          _micros[childIdx] >= _micros[rightChildIdx]) {
        childIdx = rightChildIdx;
      }
      _micros[idx] = _micros[childIdx];
      _records[idx] = _records[childIdx];
      idx = childIdx;
      childIdx = (idx << 1) + 1;
    }
    _records[idx] = newRecord;
    _micros[idx] = newRecord.microseconds;
    _siftDown(startIdx, idx);
  }

  void _siftDown(int startIdx, int idx) {
    int newMicros = _micros[idx];
    MetricRecord newRecord = _records[idx];
    // Follow the path to the root, moving parents down until finding a place
    // newMicros fits.
    while (idx > startIdx) {
      int parentIdx = (idx - 1) >> 1;
      int parentMicros = _micros[parentIdx];
      if (newMicros >= parentMicros) {
        break;
      }
      _micros[idx] = parentMicros;
      _records[idx] = _records[parentIdx];
      idx = parentIdx;
    }
    _micros[idx] = newMicros;
    _records[idx] = newRecord;
  }
}
