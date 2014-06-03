#!/bin/bash

set -e
. "$(dirname $0)/../env.sh"


# ckck echo '-----------------------'
# ckck echo '-- TEST: AngularDart --'
# ckck echo '-----------------------'
# ckck echo BROWSER=$BROWSERS
# ckck node "node_modules/karma/bin/karma" start karma.conf \
# ckck     --reporters=junit,dots --port=8765 --runner-port=8766 \
# ckck     --browsers=$BROWSERS --single-run --no-colors


echo '---------------------------'
echo '-- E2E TEST: AngularDart --'
echo '---------------------------'
$NGDART_BASE_DIR/scripts/run-e2e-test.sh


# ckck echo '==========='
# ckck echo '== BUILD =='
# ckck echo '==========='
# ckck 
# ckck SIZE_TOO_BIG_COUNT=0
# ckck 
# ckck function checkSize() {
# ckck   file=$1
# ckck   if [[ ! -e $file ]]; then
# ckck     echo Could not find file: $file
# ckck     SIZE_TOO_BIG_COUNT=$((SIZE_TOO_BIG_COUNT + 1));
# ckck   else
# ckck     expected=$2
# ckck     actual=`cat $file | gzip | wc -c`
# ckck     if (( 100 * $actual >= 105 * $expected )); then
# ckck       echo ${file} is too large expecting ${expected} was ${actual}.
# ckck       SIZE_TOO_BIG_COUNT=$((SIZE_TOO_BIG_COUNT + 1));
# ckck     fi
# ckck   fi
# ckck }
# ckck 
# ckck if [[ $TESTS == "dart2js" ]]; then
# ckck   # skip auxiliary tests if we are only running dart2js
# ckck   echo '------------------------'
# ckck   echo '-- BUILDING: examples --'
# ckck   echo '------------------------'
# ckck 
# ckck   if [[ $CHANNEL == "DEV" ]]; then
# ckck     $DART "$NGDART_BASE_DIR/bin/pub_build.dart" -p example \
# ckck         -e "$NGDART_BASE_DIR/example/expected_warnings.json"
# ckck   else
# ckck     ( cd example; pub build )
# ckck   fi
# ckck 
# ckck   (
# ckck     echo '-----------------------------------'
# ckck     echo '-- BUILDING: verify dart2js size --'
# ckck     echo '-----------------------------------'
# ckck     cd $NGDART_BASE_DIR/example
# ckck     checkSize build/web/animation.dart.js 208021
# ckck     checkSize build/web/bouncing_balls.dart.js 202325
# ckck     checkSize build/web/hello_world.dart.js 199919
# ckck     checkSize build/web/todo.dart.js 203121
# ckck     if ((SIZE_TOO_BIG_COUNT > 0)); then
# ckck       exit 1
# ckck     else
# ckck       echo Generated JavaScript file size check OK.
# ckck     fi
# ckck   )
# ckck else
# ckck   echo '--------------'
# ckck   echo '-- TEST: io --'
# ckck   echo '--------------'
# ckck   $DART --checked $NGDART_BASE_DIR/test/io/all.dart
# ckck 
# ckck   echo '----------------------------'
# ckck   echo '-- TEST: symbol extractor --'
# ckck   echo '----------------------------'
# ckck   $DART --checked $NGDART_BASE_DIR/test/tools/symbol_inspector/symbol_inspector_spec.dart
# ckck 
# ckck   $NGDART_SCRIPT_DIR/generate-expressions.sh
# ckck   $NGDART_SCRIPT_DIR/analyze.sh
# ckck 
# ckck   echo '-----------------------'
# ckck   echo '-- TEST: transformer --'
# ckck   echo '-----------------------'
# ckck   $DART --checked $NGDART_BASE_DIR/test/tools/transformer/all.dart
# ckck 
# ckck   echo '---------------------'
# ckck   echo '-- TEST: changelog --'
# ckck   echo '---------------------'
# ckck   $NGDART_BASE_DIR/node_modules/jasmine-node/bin/jasmine-node \
# ckck         $NGDART_SCRIPT_DIR/changelog/;
# ckck 
# ckck   (
# ckck     echo '---------------------'
# ckck     echo '-- TEST: benchmark --'
# ckck     echo '---------------------'
# ckck     cd $NGDART_BASE_DIR/benchmark
# ckck     $PUB install
# ckck 
# ckck     for file in *_perf.dart; do
# ckck       echo ======= $file ========
# ckck       $DART $file
# ckck     done
# ckck   )
# ckck fi
# ckck 
# ckck echo '-----------------------'
# ckck echo '-- TEST: AngularDart --'
# ckck echo '-----------------------'
# ckck echo BROWSER=$BROWSERS
# ckck $NGDART_BASE_DIR/node_modules/jasmine-node/bin/jasmine-node playback_middleware/spec/ &&
# ckck node "node_modules/karma/bin/karma" start karma.conf \
# ckck     --reporters=junit,dots --port=8765 --runner-port=8766 \
# ckck     --browsers=$BROWSERS --single-run --no-colors
# ckck 
# ckck 
# ckck echo '---------------------------'
# ckck echo '-- E2E TEST: AngularDart --'
# ckck echo '---------------------------'
# ckck $NGDART_BASE_DIR/scripts/run-e2e-test.sh
# ckck 
# ckck 
# ckck echo '-------------------------'
# ckck echo '-- DOCS: Generate Docs --'
# ckck echo '-------------------------'
# ckck if [[ $TESTS == "dart2js" ]]; then
# ckck   echo $NGDART_SCRIPT_DIR/generate-documentation.sh;
# ckck   $NGDART_SCRIPT_DIR/generate-documentation.sh;
# ckck fi
