# default arguments
method='opt'
compile=false
debug=false
nb_cores_comp=8
nb_cores_run=2

# get custom settings
while getopts "m:c:i:a:b:d:" flag
do
    case "${flag}" in
	
        m) method=${OPTARG};;
	c) compile=${OPTARG};;
	i) input_file=${OPTARG};;
	
        a) nb_cores_comp=${OPTARG};;
	b) nb_cores_run=${OPTARG};;
	d) debug=${OPTARG};;
	
    esac
done

app_name="mastodon"

# compile (c)
if [[ "${compile}" = true ]] && [[ "{$method}" = "opt" ]]; then
    make -j${nb_cores_comp}
fi

if [[ "${compile}" = true ]] && [[ "{$method}" = "dbg" ]]; then
    METHOD=dbg make -j${nb_cores_comp}
fi

# debug or run
if [[ "$debug" = true ]]; then
    gdb --args ./${app_name}-dbg -i ${input_file}
    # then use "b MPI_Abort" to add a breakpoint on error, then run "r"
    # and print variables with "p variable_name"
else
    ./${app_name}-${method} -i ${input_file} --n-threads=${nb_cores_run}
fi
