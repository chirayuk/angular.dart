part of angular.metrics;

const int MICROS_WIDTH = 10;
const int TAG_WIDTH = 10;
const String INDENT = "              ";
const int NUM_TO_REPORT_IN_LIST = 10;
const int NUM_SLOWEST_TO_REPORT = 8;
const int NUM_SLOWEST_NESTED_TO_REPORT = 8;
NumberFormat _numFmt = new NumberFormat();

_isNotNull(o) => (o != null);

_fmtTag(String tag) => (tag == null ? "" : tag).padLeft(TAG_WIDTH);

_fmtMicros(int micros) => "${_numFmt.format(micros)}µs";

_fmtMicrosPad(int micros) => "${_fmtMicros(micros).padLeft(MICROS_WIDTH)}";

_fmtMicrosList(Metrics m) =>
    m.slowestRecords.take(NUM_TO_REPORT_IN_LIST).takeWhile(_isNotNull).map((r) => _fmtMicros(r.microseconds)).join(", ");

_fmtMetrics(String prefix, Metrics m) {
  return "${prefix}${_fmtTag(m.name)}: ${_fmtMicrosPad(m.totalTimeMicro)}: (${_fmtMicrosList(m)}) count=${m.count}";
}


_groupByDetail(List<MetricRecord> records) {
  var byDetail = {};
  var byDetailCount = {};
  records.where(_isNotNull).forEach((MetricRecord record) {
    var cumulativeRecord = byDetail[record.detail];
    if (cumulativeRecord == null) {
      cumulativeRecord = byDetail[record.detail] = new MetricRecord(record.tag, record.detail, record.microseconds);
      byDetailCount[record.detail] = 1;
    } else {
      cumulativeRecord.microseconds += record.microseconds;
      byDetailCount[record.detail] += 1;
    }
  });
  var result = byDetail.values.map((r) {r.detail = "${r.detail}: count=${byDetailCount[r.detail]}"; return r;}).toList();
  result.sort((a, b) => b.microseconds - a.microseconds);
  return result;
}


_fmtSlowMetrics(String prefix, Metrics m) {
  String nestedPrefix = "$prefix  ${''.padLeft(TAG_WIDTH)}";
  // return m.slowestRecords.take(NUM_SLOWEST_TO_REPORT).takeWhile(_isNotNull).map(
  //     (r) => "${nestedPrefix}${_fmtMicrosPad(r.microseconds)}: ${r.detail}").join("\n");
  return _groupByDetail(m.slowestRecords).take(NUM_SLOWEST_TO_REPORT).takeWhile(_isNotNull).map(
      (r) => "${nestedPrefix}${_fmtMicrosPad(r.microseconds)}: ${r.detail}").join("\n");
}

_fmtSlowNestedMetrics(String prefix, Metrics m) {
  String nestedPrefix = "$prefix  ${''.padLeft(TAG_WIDTH)}";
  return m.slowestRecords.take(NUM_SLOWEST_NESTED_TO_REPORT).takeWhile(_isNotNull).map(
      (r) => "${nestedPrefix}${_fmtMicrosPad(r.microseconds)}: ${r.detail.name}\n${r.detail.toString(nestedPrefix+INDENT)}").join("\n");
}


class Metrics {
  int totalTimeMicro = 0;
  int count = 0;
  final List<MetricRecord> slowestRecords;
  String name;
  double _avgTimeMicro = 0.0;

  MetricRecord get slowest => slowestRecords.isEmpty ? null : slowestRecords.first;
  MetricRecord get fastest => slowestRecords.isEmpty ? null : slowestRecords.last;

  Metrics.copy(Metrics other):
      totalTimeMicro = other.totalTimeMicro,
      count = other.count,
      slowestRecords = new List.from(other.slowestRecords, growable: false),
      name = other.name,
      _avgTimeMicro = other.avgTimeMicro;

  // fixed size list.
  Metrics._internal(int capacity): slowestRecords = new List<MetricRecord>(capacity);

  void _update(MetricsCollector collector) {
    _avgTimeMicro = null;
    totalTimeMicro = collector.totalTimeMicro;
    count = collector.count;
    collector._heap.storeSortedRecords(slowestRecords);
    name = collector.name;
  }

  double get avgTimeMicro {
    if (_avgTimeMicro == null) {
      _avgTimeMicro = (count > 0) ? (totalTimeMicro / count) : 0.0;
    }
    return _avgTimeMicro;
  }

  toString() =>
      "$name(total=${totalTimeMicro}µs, slowest=$slowest, avg=${avgTimeMicro}µs, count=$count)";
}


@Injectable()
class MetricsCollector {
  final String name;

  MetricsHeap _heap = new MetricsHeap(NUM_SLOWEST_ITEMS);

  // Returns a list of the slowest records in descending order.
  List<MetricRecord> get slowestRecords => _heap.sortedRecords;

  // 
  bool enabled = true; // ckck
  bool _haveListeners = false;
  StreamController<MetricsCollector> _streamController;

  bool _dirty = false;
  final Metrics _metrics;

  Metrics get metrics {
    if (_dirty) {
      _dirty = false;
      _metrics._update(this);
    }
    return _metrics;
  }

  MetricsCollector(this.name): _metrics = new Metrics._internal(NUM_SLOWEST_ITEMS) {
    _streamController = new StreamController<MetricsCollector>.broadcast(
        onListen: () { _haveListeners = true;  },
        onCancel: () { _haveListeners = false; },
        sync: true);
  }

  // Number of items that were counted toward this collection.
  int count = 0;
  int totalTimeMicro = 0;

  void reset() {
    _dirty = false;
    _heap.reset();
    count = 0;
    totalTimeMicro = 0;
  }

  void record(String tag, dynamic detail, int elapsedMicros) {
    // DEBUGGING: Normally we record only if there are any active listeners.
    // Currently, there are none and we're just printing to console so skip the
    // _haveListeners check.
    //
    // ckck if (elapsedMicros > THRESHOLD_MICRO && enabled && _haveListeners) {
    if (elapsedMicros > THRESHOLD_MICRO && enabled) { // ckck
      _record(tag, detail, elapsedMicros);
    }
  }

  _record(String tag, dynamic detail, int elapsedMicros) {
    count++;
    _dirty = true;
    totalTimeMicro += elapsedMicros;
    _heap.record(tag, detail, elapsedMicros);
  }

  void notifyListeners() {
    if (enabled && _haveListeners) {
      controller.add(metrics);
    }
  }

  Stream<MetricsCollector> get stream => _streamController.stream;

  toString() => metrics.toString();
}


@Injectable()
class MetricRecord {
  //ckck final int microseconds;
  int microseconds; // ckck
  final String tag;
  //ckck final Object detail;
  Object detail;
  // const MetricRecord(this.tag, this.detail, this.microseconds);
  MetricRecord(this.tag, this.detail, this.microseconds);
  toString() => "$tag(${microseconds}µs for $detail)";
}


class DigestPhaseMetrics {
  final String name;
  final Metrics runAsyncMetrics;
  final Metrics dirtyCheckMetrics;
  final Metrics dirtyOnChangeMetrics;
  final Metrics evalPhaseMetrics;
  final Metrics reactionFnMetrics;
  final Metrics domReadMetrics;
  final Metrics domWriteMetrics;

  DigestPhaseMetrics(DigestPhaseCollectors digestPhaseCollectors):
      name = digestPhaseCollectors.name,
      runAsyncMetrics = new Metrics.copy(digestPhaseCollectors.runAsync.metrics),
      dirtyCheckMetrics = new Metrics.copy(digestPhaseCollectors.dirtyCheck.metrics),
      dirtyOnChangeMetrics = new Metrics.copy(digestPhaseCollectors.dirtyOnChange.metrics),
      evalPhaseMetrics = new Metrics.copy(digestPhaseCollectors.evalPhase.metrics),
      reactionFnMetrics = new Metrics.copy(digestPhaseCollectors.reactionFnPhase.metrics),
      domReadMetrics = new Metrics.copy(digestPhaseCollectors.domRead.metrics),
      domWriteMetrics = new Metrics.copy(digestPhaseCollectors.domWrite.metrics);

  _fmtPhaseMetrics(String prefix, Metrics m) {
    if (m.name == null) {
      return null;
    }
    return "${_fmtMetrics(prefix, m)}\n${_fmtSlowMetrics(prefix, m)}";
  }

  toString([String prefix=""]) {
    return [
        _fmtPhaseMetrics(prefix, runAsyncMetrics),
        _fmtPhaseMetrics(prefix, dirtyCheckMetrics),
        _fmtPhaseMetrics(prefix, dirtyOnChangeMetrics),
        _fmtPhaseMetrics(prefix, evalPhaseMetrics),
        _fmtPhaseMetrics(prefix, reactionFnMetrics),
        _fmtPhaseMetrics(prefix, domReadMetrics),
        _fmtPhaseMetrics(prefix, domWriteMetrics),
        ].where(_isNotNull).join("\n");
  }
}


class DigestPhaseCollectors {
  final String name;
  DigestPhaseCollectors(this.name);

  MetricsCollector runAsync        = new MetricsCollector("RunAsync");
  MetricsCollector dirtyCheck      = new MetricsCollector("DirtyCheck");
  MetricsCollector dirtyOnChange   = new MetricsCollector("DirtyOnChange");
  MetricsCollector evalPhase       = new MetricsCollector("Eval");
  MetricsCollector reactionFnPhase = new MetricsCollector("ReactionFn");
  MetricsCollector domRead         = new MetricsCollector("DomRead");
  MetricsCollector domWrite        = new MetricsCollector("DomWrite");

  reset() {
    runAsync.reset();
    dirtyCheck.reset();
    dirtyOnChange.reset();
    evalPhase.reset();
    reactionFnPhase.reset();
  }

  toString() => "$runtimeType[$name]:\n\t$runAsync\n\t$dirtyCheck\n\t$dirtyOnChange\n\t$evalPhase\n\t$reactionFnPhase";
}


class RootScopeMetrics {
  final String name;
  final Metrics iterationMetrics;
  final DigestPhaseMetrics flushMetrics;
  // TODO: These should go into MetricRecords.
  final int digestMicros;
  final int flushMicros;

  RootScopeMetrics(RootScopeCollectors rsCollectors):
      name = rsCollectors.name,
      digestMicros = rsCollectors.digestMicros,
      flushMicros = rsCollectors.flushMicros,
      iterationMetrics = rsCollectors.slowestIterations.metrics,
      flushMetrics = new DigestPhaseMetrics(rsCollectors.flushCollectors);

  toString([String prefix=""]) {
    return "${_fmtMetrics(prefix, iterationMetrics)}\n${_fmtSlowNestedMetrics(prefix, iterationMetrics)}" +
        "\n" +
        "${prefix}${_fmtTag(flushMetrics.name)}: ${_fmtMicrosPad(flushMicros)}\n${flushMetrics.toString(prefix + INDENT)}";
  }
}


class RootScopeCollectors {
  final String name;
  bool enabled = true; // ckck
  int digestMicros;
  int flushMicros;

  List<DigestPhaseCollectors> iterationCollectors;
  DigestPhaseCollectors flushCollectors = new DigestPhaseCollectors("Flush");
  MetricsCollector slowestIterations = new MetricsCollector("Digest");
  // This one is across digests while the rest are for the most recent digest.
  MetricsCollector slowestDigests = new MetricsCollector("SlowestDigests");

  RootScopeCollectors(this.name, int ttl) {
    assert(ttl >= 1);
    iterationCollectors = new List<DigestPhaseCollectors>.generate(
        ttl, ((i) => new DigestPhaseCollectors("Iteration $i")), growable: false);
  }

  resetIterationCollectors() {
    iterationCollectors.forEach((c) => c.reset());
    slowestIterations.reset();
    digestMicros = null;
  }

  resetFlushPhaseCollectors() {
    flushCollectors.reset();
  }

  reset() {
    resetPhaseCollectors();
    resetFlushPhaseCollectors();
    slowestDigests.reset();
  }

  toString() {
    return "$runtimeType[$name](\n\tdirtyCheckingMetrics: $dirtyCheckingMetrics)";
  }
}
