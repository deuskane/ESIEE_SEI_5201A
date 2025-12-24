#!/bin/bash

SOURCE_FILE=labo.drawio

FILENAME=$(basename "$SOURCE_FILE" .drawio)
OUTPUT_DIR="."
mkdir -p "$OUTPUT_DIR"

drawio --uncompressed -x -o ${SOURCE_FILE}.xml "${SOURCE_FILE}"
PAGES=`grep -o 'name="[^"]*"' ${SOURCE_FILE}.xml|sed 's/name="//;s/"//'`

INDEX=0

for PAGE in ${PAGES}
do
    OUTPUT_FILE="${OUTPUT_DIR}/${FILENAME}-${PAGE}.png"
    
    drawio --export \
           --format png \
           --scale 2 \
           --page-index "${INDEX}" \
           --output "$OUTPUT_FILE" \
           "$SOURCE_FILE" 2>/dev/null

    INDEX=$((${INDEX}+1))
    
done

echo "-----------------------------------------------"
echo "Exportation terminée dans le dossier : $OUTPUT_DIR"
