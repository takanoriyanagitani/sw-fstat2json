#!/bin/sh

ENV_FILENAME=./example.sh ./FilenameToStatToJson |
  jq
