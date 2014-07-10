#!/bin/bash

set -e
. "$(dirname $0)/../env.sh"

export SAUCE_ACCESS_KEY=`echo $SAUCE_ACCESS_KEY | rev`

echo '---------------------------'
echo '-- E2E TEST: AngularDart --'
echo '---------------------------'
$NGDART_BASE_DIR/scripts/run-e2e-test.sh
