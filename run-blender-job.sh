#!/bin/bash
#
# Blender Render Job
# ------------------
# Designed to be run in container instanced by AWS Batch
#
# Downloads blender file from AWS S3
# Renders frames in specified range
# Uploads rendered frames to AWS S3
# 
# Parameters: [start frame] [end frame]
#
# Environment variables (AWS S3 locations):
#
# BLENDER_S3_URL        - source .blend file 
# FRAME_S3_URL          - destination folder to upload rendered frames to
#
#

COUNTER=$1

echo "Blender Render Job"
echo "------------------"
echo "jobId: $AWS_BATCH_JOB_ID"
echo "jobQueue: $AWS_BATCH_JQ_NAME"
echo "computeEnvironment: $AWS_BATCH_CE_NAME"

# Copy target blender file from s3
aws s3 cp $BLENDER_S3_URL .

mkdir frames

# render frames from parameters $1 to $2 and copy into s3
while [ $COUNTER -le $2 ]; do
        blender -b *.blend -o frames/ -F PNG -E CYCLES -f $COUNTER
        aws s3 cp frames/  $FRAME_S3_URL --recursive
        rm frames/*
        let COUNTER=COUNTER+1
done
