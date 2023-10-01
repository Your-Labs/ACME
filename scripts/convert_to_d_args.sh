#!/bin/bash

convert_to_d_args() {
    local last_arg="${!#}"  # Get the last argument
    local include_wildcard=false  # default to false

    # check if the last argument is "true"
    if [ "$last_arg" == "true" ]; then
        include_wildcard=true
        # if the last argument is "true", then remove it from the list of domains
        local domains=("${@:1:$#-1}")
    elif [ "$last_arg" == "false" ]; then
        include_wildcard=false
        # if the last argument is "false", then remove it from the list of domains
        local domains=("${@:1:$#-1}")
    else
        # if the last argument is not "true", then use all the arguments as domains
        local domains=("$@")
    fi

    local args=""
    for domain in "${domains[@]}"; do
        args="$args -d $domain"
        # if the last argument is "true", then add the wildcard domain
        if [ "$include_wildcard" == "true" ]; then
            args="$args -d *.$domain"
        fi
    done

    echo "$args"
}

ARGS=$(convert_to_d_args $@)
echo $ARGS

# DOMAINS="example.com example.org abcd.com"
# D_ARGS=$(convert_to_d_args $DOMAINS false)
# echo $D_ARGS
