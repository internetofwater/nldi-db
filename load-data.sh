#!/bin/bash

FILE="$(pwd)/.env"
if [ -f "$FILE" ]; then
    echo Using "$FILE" for environment
    source "$FILE"
fi

FILE_ORDER=(
    "catchmentsp"
    "megadiv_np21"
    "nhdflowline_np21"
    "nhdplusconnect_np21"
    "plusflow_np21"
    "plusflowlinevaa_np21"
    "characteristic_data.plusflowlinevaa_np21"
    "characteristic_data.catchmentsp"
)

declare -A FILES
FILES=(
    [catchmentsp]=nhdplus
    [megadiv_np21]=nhdplus
    [nhdflowline_np21]=nhdplus
    [nhdplusconnect_np21]=nhdplus
    [plusflow_np21]=nhdplus
    [plusflowlinevaa_np21]=nhdplus
    [characteristic_data.plusflowlinevaa_np21]=characteristic_data
    [characteristic_data.catchmentsp]=characteristic_data
)

problem_files=()

for i in "${FILE_ORDER[@]}"; do
    error=false
    filename=${i}
    namespace=${FILES[$i]}

    if [ ! -f "${filename}.pgdump" ]; then 
        if [ ! -f "${filename}.pgdump.gz" ]; then  
            aws s3 cp "s3://${NLDI_BUCKET_NAME}/${filename}.pgdump.gz" . || exit 1
        fi
        gunzip -k -d "${filename}.pgdump.gz" || exit 2
    fi
    
    pg_restore "$(pwd)/${filename}.pgdump" -h "${NLDI_DATABASE_ADDRESS}" -p 5432 -a -U postgres --no-password -d nldi -n "${namespace}" --verbose || error=true
    
    if [ $error = true ]; then
        problem_files+=("${filename}")
    fi
done

echo "Files with errors:"
echo "${problem_files[@]}"

exit 0
