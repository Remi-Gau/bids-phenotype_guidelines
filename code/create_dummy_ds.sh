#!/bin/bash

# small bash script to create a dummy BIDS data set

# defines where the BIDS data set will be created
start_dir=$(pwd) # relative to starting directory
raw_dir=${start_dir}/../examples

subject_list='01 02' # subject list
session_list='01 02' # session list
tool_names='tool1 tool2'

init() {

	target_dir=$1

	mkdir -p ${target_dir}

	touch ${target_dir}/README

	template='{"Name":%s, "BIDSVersion": "1.4.0", "DatasetType": "raw"}'
	json_string=$(printf "${template}" '"phenotype example 1"')
	echo "$json_string" >${target_dir}/dataset_description.json

}

create_phenotype() {

	target_dir=$1
	subject=$2
	ses=$3
	tool=$3

	suffix='_'"${tool}"

	this_dir=${target_dir}/sub-${subject}/ses-${ses}/phenotype

	mkdir -p "${this_dir}"

	scans_tsv=${target_dir}/sub-${subject}/ses-${ses}/sub-${subject}_ses-${ses}_scans.tsv
	echo "filename\tacq_time" >"${scans_tsv}"

	for run in $(seq 1 2); do
		filename=${this_dir}/sub-${subject}_ses-${ses}_run-${run}${suffix}.tsv
		echo "something\tsomething_else\tanother_thing" >"${filename}"
		echo "2\t2\tVisMotUp" >>"${filename}"
		echo "4\t2\tVisMotDown" >>"${filename}"

		acq_time=$(date +'%Y-%m-%dT%H:%M:%S')
		echo "sub-${subject}/ses-${ses}/phenotype\t${acq_time}" >>"${scans_tsv}"
	done

}

# RAW DATASET

init "${raw_dir}"

for subject in ${subject_list}; do
	for ses in ${session_list}; do
		for tool in ${tool_names}; do
			create_phenotype "${raw_dir}" "${subject}" "${ses}" "${tool}"
		done
	done
done
