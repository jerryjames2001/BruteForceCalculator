#!/bin/bash

# loading screen
loading_screen() {
    echo -n "Calculating"
    local spin='-\|/'
    local i=0
    local delay=$1
    while [ $delay -gt 0 ]; do
        i=$(( (i + 1) % 4 ))
        printf "\b${spin:$i:1}"
        sleep 0.1
        delay=$((delay - 1))
    done
    printf "\b Done!\n"
}

# cracker
estimate_cracking_time() {
    local password="$1"
    local hashes_per_second="$2"

    lowercase="abcdefghijklmnopqrstuvwxyz"
    uppercase="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    digits="0123456789"
    special_chars="!@#$%^&*()-_=+[]{}|;:'\,.<>?/~"

    character_set=""
    for (( i=0; i<${#password}; i++ )); do
        char="${password:$i:1}"
        if [[ "$lowercase" == *"$char"* ]] && ! [[ "$character_set" == *"$lowercase"* ]]; then
            character_set+="$lowercase"
        fi
        if [[ "$uppercase" == *"$char"* ]] && ! [[ "$character_set" == *"$uppercase"* ]]; then
            character_set+="$uppercase"
        fi
        if [[ "$digits" == *"$char"* ]] && ! [[ "$character_set" == *"$digits"* ]]; then
            character_set+="$digits"
        fi
        if [[ "$special_chars" == *"$char"* ]] && ! [[ "$character_set" == *"$special_chars"* ]]; then
            character_set+="$special_chars"
        fi
    done

    password_length=${#password}
    character_set_size=${#character_set}
    search_space=$(( character_set_size ** password_length ))

    # Calculate time in seconds
    time_to_crack=$(( search_space / hashes_per_second ))

    # econds to human-readable format
    years=$(( time_to_crack / (365 * 24 * 3600) ))
    time_to_crack=$(( time_to_crack % (365 * 24 * 3600) ))
    months=$(( time_to_crack / (30 * 24 * 3600) ))
    time_to_crack=$(( time_to_crack % (30 * 24 * 3600) ))
    days=$(( time_to_crack / (24 * 3600) ))
    time_to_crack=$(( time_to_crack % (24 * 3600) ))
    hours=$(( time_to_crack / 3600 ))
    time_to_crack=$(( time_to_crack % 3600 ))
    minutes=$(( time_to_crack / 60 ))
    seconds=$(( time_to_crack % 60 ))


    echo "Estimated cracking time:"
    echo "$years years, $months months, $days days, $hours hours, $minutes minutes, $seconds seconds"
}

# Input password and hashing speed
read -p "Enter your password: " password
read -p "Enter the hashing speed (hashes/second): " hashes_per_second


loading_screen 50 #adjust the timr if neede 50 = 5 seconds


estimate_cracking_time "$password" "$hashes_per_second"
