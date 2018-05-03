#!/usr/bin/env bash
function list_modified_md_files {
    if [ -z $TRAVIS_PULL_REQUEST_BRANCH ]; then
        find . -name \*.md -print || true
    else
        git diff --name-only $(git merge-base HEAD master) | grep "\.md$" || true
    fi
}

function spellcheck {
    if [ "$ENABLE_CHECK" = "true" ]; then
        if [ -z $TRAVIS_PULL_REQUEST_BRANCH ]; then
            yaspeller --max-requests 10 --dictionary .yaspeller-dictionary.json -e ".md" ./
            if [ "$1" != "--single" ]; then
                spellchecker --language=en-US --plugins spell repeated-words syntax-mentions syntax-urls --ignore "[A-Zx0-9./_-]+" "[u0-9a-fA-F]+" "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z" "[0-9dhms:-]+" "(metric|entity|tag|[emtv])[:0-9]*" --dictionary=.spelling --files '**/*.md'
            fi
        else
            list_modified_md_files | xargs -d '\n' -n1 yaspeller --dictionary .yaspeller-dictionary.json {}
            if [ "$1" != "--single" ]; then
                list_modified_md_files | xargs -d '\n' -n1 spellchecker --language=en-US --plugins spell repeated-words syntax-mentions syntax-urls --ignore "[A-Zx0-9./_-]+" "[u0-9a-fA-F]+" "[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z" "[0-9dhms:-]+" "(metric|entity|tag|[emtv])[:0-9]*" --dictionary=.spelling --files {}
            fi
        fi
    else
        echo "Spell checking will be skipped"
    fi
}

function linkcheck {
    if [ "$ENABLE_CHECK" = "true" ]; then
        list_modified_md_files | xargs -d '\n' -n1 markdown-link-check
    else
        echo "Link checking will be skipped"
    fi
}

function stylecheck {
    if [ "$ENABLE_CHECK" = "true" ]; then
        if [ -z $TRAVIS_PULL_REQUEST_BRANCH ]; then
            markdownlint .
        else
            if [[ -n "$(list_modified_md_files)" ]]; then
                list_modified_md_files | xargs -d '\n' -n1 markdownlint
            fi;
        fi
    else
        echo "Style checking will be skipped"
    fi
}

function print_modified_markdown_files {
    echo "Files to be checked:"
    list_modified_md_files
}

function generate_yaspeller_dictionary {
    cat "$@" | awk '{$1=$1};1' | sort -u | jq -csR 'split("\n")' > .yaspeller-dictionary.json
}

function install_checkers {
    npm install --global --production yaspeller spellchecker-cli markdown-link-check markdownlint-cli
    if [ "$TRAVIS_REPO_SLUG" != "axibase/atsd" ]; then
        wget https://raw.githubusercontent.com/axibase/atsd/master/.spelling -O .spelling-atsd
        cat .spelling-atsd .dictionary > .spelling
        if [ ! -f .dictionary ]; then
            touch .dictionary
        fi
        if [ ! -f .markdownlint.json ]; then
            wget https://raw.githubusercontent.com/axibase/atsd/master/.markdownlint.json
        fi
        if [ ! -f .yaspellerrc ]; then
            wget https://raw.githubusercontent.com/axibase/atsd/master/.yaspellerrc
        fi
    fi
    generate_yaspeller_dictionary .spelling
}

function install_checkers_in_non_doc_project {
    if [ "$TRAVIS_JOB_NUMBER" = "$TRAVIS_BUILD_NUMBER.1" ]; then
        nvm install 8 && nvm use 8
        install_checkers
    else
        export ENABLE_CHECK=false
    fi
}

export ENABLE_CHECK=true
