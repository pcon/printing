function render_single() {
	local dest_folder="${1}"
	local stl_file="${2}"
	local scad_file="${3}"
	local option_array="${@:4}"
	local options="${option_array// /;}"

	echo "  - RENDERING - ${stl_file}"
	openscad -q -D "${options}" -o "${dest_folder}/${stl_file}" "${scad_file}"
}

function render_multipart() {
	local dest_folder="${1}"
	local stl_file="${2}"
	local scad_file="${3}"
	local options="${@:4}"

	render_single "${dest_folder}" "${stl_file}" "${scad_file}" "multiPartOutput=\"${stl_file}\"" ${options}
}

function process_single() {
	local dest_folder="${1}"
	local single_part_files="${2}"

	for file in ${single_part_files[@]}; do
		stl_file="${file}.stl"
		scad_file="${file}.scad"

		echo "PROCESSING - ${scad_file}"

		render_single "${dest_folder}" "${stl_file}" "${scad_file}"
	done
}

function process_multipart() {
	local dest_folder="${1}"
	local multi_part_files="${2}"
	local hollow_bottoms="${3}"

	for multipart in ${multi_part_files[@]}; do
		IFS=":" read -r -a parts <<<"${multipart}"
		IFS=";" read -r -a files <<<"${parts[1]}"
		scad_file="${parts[0]}.scad"

		echo "PROCESSING - ${scad_file}"

		for file in ${files[@]}; do
			stl_file="${file}.stl"
			render_multipart "${dest_folder}" "${stl_file}" "${scad_file}"

			if [[ ${hollow_bottoms[@]} =~ ${file} ]]; then
				solid_stl_file="${file}_solid.stl"
				render_multipart "${dest_folder}" "${solid_stl_file}" "${scad_file}" "HOLLOW_BOTTOM=false"
			fi
		done
	done
}
