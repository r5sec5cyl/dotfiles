#!/bin/bash
# flags.sh

contains_flag() {
    local flags=($(echo ,$1 | sed 's#,# #g'))
    for param in "${@:2}"; do
        for flag in "${flags[@]}"; do
            if [[ "$param" == "$flag" ]]; then
                return 0
            fi
            if [[ "$flag" =~ ^\-[a-zA-Z]$ ]]; then
                local flag_char=${flag:1:1}
                if [[ "$param" =~ ^\-[a-zA-Z]*"$flag_char"[a-zA-Z]*$ ]]; then
                    return 0
                fi
            fi
        done
    done
    return 1
}

arg_value() {
    local return_value=1
    local try_next_param=0
    local args=($(echo ,$1 | sed 's#,# #g'))
    for param in "${@:2}"; do
        local key=""
        if [[ "$param" =~ .*=.* ]]; then
            local key=$(echo $param | sed 's#=.*##g')
        fi
        for arg in "${args[@]}"; do
            if [[ "$key" == "$arg" ]]; then
                echo $param | sed 's#[^=]*=##'
                return_value=0 && break
            fi
            if [ $try_next_param -eq 1 ]; then
                local try_next_param=0
                if [[ "${param:0:1}" != "-" ]]; then
                    echo ,$param | sed 's#^,##'
                    return_value=0 && break
                fi
            fi
            if [[ "$param" == "$arg" ]]; then
                local try_next_param=1
                break
            fi
            if [[ "$arg" =~ ^\-[a-zA-Z]$ ]]; then
                local arg_char=${arg:1:1}
                if [[ "$param" =~ ^\-[a-zA-Z]*"$arg_char"$ ]]; then
                    local try_next_param=1
                    break
                fi
            fi
        done
    done;
    return $return_value
}

# flags_example() {
#     sample_flagged_fn() {
#         echo ----------------
#         printf "${LT_GREEN}" && echo flags: "$@" && printf "${DEFAULT_FMT}"
#         contains_flag --first-flag "$@" && echo "contains --first-flag"
#         contains_flag -a "$@" && echo "contains -a"
#         contains_flag -b "$@" && echo "contains -b"
#         contains_flag -c "$@" && echo "contains -c"
#         contains_flag -d "$@" && echo "contains -d"
#         contains_flag -e "$@" && echo "contains -e"
#         contains_flag --last-flag "$@" && echo "contains --last-flag"
#         f_arg=$(arg_value -f,myarg "$@") && printf "flag -f is set to ${RED}$f_arg${DEFAULT_FMT}\n"
#         printf "Volumes found: \n"
#         # volumes=($(arg_value --volume,-v,volume "$@" | awk '{print $0}')) # TODO: fix space-defined array breaks on spaces uggh
#         i=0 && declare -a volumes
#         arg_value --volume,-v,volume "$@" | { while read vol; do i+=1;volumes[$i]="$vol"; done }
#         for volume in ${volumes[@]}; do printf "${YELLOW}|$volume|${DEFAULT_FMT}\n"; done
#         echo ----------------
#     }
#     sample_flagged_fn --last-flag -c -a -b --first-flag "you can pass flags in any order"
#     sample_flagged_fn -bac "you can stack single dash single letter flags"
#     sample_flagged_fn -abv ./you/can/pass/arg/to/last/stacked/flag
#     sample_flagged_fn -e -f "notice -e didn't break things; all flags are safe"
#     sample_flagged_fn -af "won't capture a flag parameter like -s unless it's an actual flag"
#     sample_flagged_fn --volume ./some/file --volume "./some other/file" -f "you can overload flag args"
#     sample_flagged_fn -av "you can overload" volume="flags themselves" --volume "here we allow -v --volume volume"
#     sample_flagged_fn volume="-e" volume="you|can" volume="have:any" volume="char\$as" volume="value=even=equals"
#     unset sample_flagged_fn
# }
