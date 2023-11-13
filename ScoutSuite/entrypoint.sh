#!/bin/bash

# Stop on error
set -e

# need ENV: S3_BUCKET, S3_PREFIX
if [ -z "$S3_BUCKET" -o -z "$S3_PREFIX" ]; then
    echo "ERROR: missing S3_BUCKET and/or S3_PREFIX environment variables"
    exit 1
fi

DT=$(date '+%Y-%m-%d-%H%M')
OUTPUT_DIR="scout-${DT}"
OUTPUT_FILE="$OUTPUT_DIR.tar.gz"
S3_DEST="s3://$S3_BUCKET/$S3_PREFIX/$OUTPUT_FILE"

if [ -v AWS_LAMBDA_RUNTIME_API ]; then
    # Executing in Lambda, indicate the start of invocation and save the Lambda request ID
    # -s hides progress bar
    # -w '%header{Lambda-Runtime-Aws-Request-Id}' prints to stdout the value of the header that Lambda uses to pass request ID
    # -o /dev/null sends response contents to /dev/null
    LAMBDA_REQUEST_ID=$(curl -s -o /dev/null -w '%header{Lambda-Runtime-Aws-Request-Id}' "http://$AWS_LAMBDA_RUNTIME_API/2018-06-01/runtime/invocation/next")
    echo "Executing as Lambda, request ID: $LAMBDA_REQUEST_ID"
fi

echo "Running ScoutSuite scan"
# output directory
[ -d "$OUTPUT_DIR" ] || mkdir "$OUTPUT_DIR"
scout aws --report-dir "$OUTPUT_DIR" "$@"

# save report to S3
echo "Saving ScoutSuite report to $S3_DEST"
tar czf "$OUTPUT_FILE" "$OUTPUT_DIR"
aws s3 cp --quiet "$OUTPUT_FILE" "$S3_DEST"

if [ -v AWS_LAMBDA_RUNTIME_API ]; then
    # Executing in Lambda, indicate the execution was successful
    RESULT="\{\"result\": \"SUCCESS\", \"report_location\": \"$S3_DEST\"\}"
    curl -s -o /dev/null "http://$AWS_LAMBDA_RUNTIME_API/2018-06-01/runtime/invocation/$LAMBDA_REQUEST_ID/response"  -d "$RESULT"
fi
