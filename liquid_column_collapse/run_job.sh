#!/bin/bash
set -e
for refinement in 10
do
    [ -f refinement_level.txt ] && rm refinement_level.txt
    echo "$refinement" > refinement_level.txt

    time_stamp=$(date +"%Y.%m.%d_%T")
    job=column_collapse_${refinement}_refinement_${time_stamp}

    mkdir ./${job}
    mpirun -n 4 parun tank_so.py -l 3 -O ./petsc.options.asm -D ./${job}

    # cleanup
    mv mesh.* ${job}
    # only call mv here if csv files were created
    [ '*.csv' = "$(echo *.csv)" ] || mv *.csv ${job}
done
