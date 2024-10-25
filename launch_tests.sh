#!/bin/bash

# django-check-seo super test-launching script
#
# requires python3-venv
#
# Usage:
#    ./launch_tests.sh           activate venv2 (or create it & activate it),
#                                launch tests, deactivate venv2
#    ./launch_tests.sh remove    remove folders for "venv2"
#    ./launch_tests.sh help      display this text

function remove {

    if [[ -d "venv2" ]]; then

        echo -e "\e[1;32m✅ test venv2 found\e[0m"
        echo -e "\e[2m➡ removing venv2...\e[0m"
        rm -r venv2
        echo -e "\e[1;32m✅ test venv2 removed successfully\e[0m"
    else
        echo -e "\e[1;31m❌ test venv2 not found\e[0m"
        echo -e "\e[1;32m✅ nothing to remove\e[0m"
    fi

}

function display_help {

    echo -e "django-check-seo super test-launching script"
    echo
    echo -e "Usage:"
    echo -e "    ./launch_tests.sh           \e[2mactivate venv2 & (or create it & activate it), launch tests, deactivate venv2\e[0m"
    echo -e "    ./launch_tests.sh remove    \e[2mremove folders \"venv2\"\e[0m"
    echo -e "    ./launch_tests.sh help      \e[2mdisplay this text\e[0m"

}

function create_and_launch_venv2 {

    if [[ -d "venv2" ]]; then
        launch_venv2_tests
    else
        create_venv2
    fi

}

function launch_venv2_tests {

    echo -e "\e[1;32m✅ test venv2 found\e[0m"
    echo -e "\e[2m➡ launching tests...\e[0m"
    . venv2/bin/activate && python3 -m pytest -s --cov-config=.coveragerc --cov=django_check_seo --cov-report term-missing && deactivate

}

function create_venv2 {

    echo -e "\e[1;31m❌ test venv2 not found\e[0m"
    echo -e "\e[2m➡ creating venv2...\e[0m"
    python3 -m venv venv2 1>/dev/null && . venv2/bin/activate && python3 -m pip install django bs4 lxml djangocms-page-meta requests Unidecode pytest pytest-django pytest-cov 1>/dev/null && deactivate
    echo -e "\e[1;32m✅ venv2 created successfully\e[0m"
    echo -e "\e[2m➡ launching tests...\e[0m"
    . venv2/bin/activate && python3 -m pytest -s --cov-config=.coveragerc --cov=django_check_seo --cov-report term-missing && deactivate

}


if [[ $1 == "remove" ]]; then

    remove

    exit 1

elif [[ $1 == "help" ]]; then

    display_help

    exit 1

elif [[ $1 == "3" ]]; then

    create_and_launch_venv2

    exit $?

elif [[ "$#" -gt 0 ]]; then

    if [[ $1 != ".pre-commit-config.yaml" || $2 != "launch_tests.sh" ]]
    then
        echo "Wrong args:"
        echo $@
        echo ""
        display_help
        exit 1
    fi

fi

create_and_launch_venv2

exit1=$?

if [ "$exit1" -eq "0" ]
then
    exit 0
else
    exit 1
fi
