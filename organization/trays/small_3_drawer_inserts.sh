#!/bin/bash

BASE_PATH=$(realpath "../../")
source "${BASE_PATH}/scripts/helpers.sh"

FOLDER="models/small_3_drawer_inserts"
SRC_FILE="small_3_drawer_inserts:front_half_split_2;back_half_split_4"

process_multipart "${FOLDER}" "${SRC_FILE}"
