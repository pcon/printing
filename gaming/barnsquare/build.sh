#!/bin/bash

partNames=("base" "square" "triangle" "rhombus")

for part in "${partNames[@]}"; do
	stlFile="parts/${part}.stl"
	scadFile="part_${part}.scad"
	echo "Generating - ${part}"
	openscad -q -o "${stlFile}" "${scadFile}"
done
