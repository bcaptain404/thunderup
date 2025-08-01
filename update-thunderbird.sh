#!/bin/bash

set -e

function Usage() {
    echo "## Usage: $0 [version] # you may omit [version] to force an automatic check." >&2
}

function DownloadFile() {
    local URL="$1"
    local TO="$(realpath "$2")"
    local DWN="$(dirname "$TO")"
    local TMP="$DWN/_$(basename "$TO")"

    echo "## Will download $URL to $TO" >&2
    
    mkdir -p "$DWN" || true
    [ -d "$DWN" ] || {
        echo "ERROR: could not mkdir -p: $DWN" >&2
        return 9
    }
    
    if [ -e "$TMP" ] ; then
        echo "## NOTE: Removing previous failed fownload: $TMP" >&2
        rm "$TMP"
    fi

    if [[ -e "$TO" ]] ; then
        echo "## Already previously downloaded!" >&2
        echo "## Note: Download exists at: $TO" >&2
        echo "## Note: File previously downloaded. To force re-download, please delete $TO" >&2
        return 0
    fi

    echo "## Downloading..." >&2
    rm "$TMP" 2>/dev/null || true

    wget -q "$URL" -O "$TMP" 2>/dev/null || {
        echo "## ERROR: failed to download" >&2
        echo "## NOTE: Removing failed download" >&2
        rm "$TMP" 2>/dev/null || true
        return 4
    }

    mv -n "$TMP" "$TO"
    echo "## Download complete: $TO" >&2

    if [[ ! -e "$TO" ]] ; then
        echo "## ERROR: downloaded package went missing: $TO" >&2
        return 5
    fi
}

function GetVer() {
    local PAGE_URL="$1"
    local NEW_VER="$2"

    if [[ "$NEW_VER" != "" ]] ; then
        echo "## Updating to $NEW_VER (as specified on commandline)" >&2
        echo "$NEW_VER"
        return 0
    fi

    function GetLatestVer() {
        local BROWSER='Mozilla/5.0'
        local OS="Windows NT 10.0; WOW64"
        local BS="AppleWebKit/537.36 (KHTML, like Gecko)"
        local OBS="Chrome/51.0.2704.103 Safari/537.36"
        local USER_AGENT="$BROWSER ($OS) $BS $OBS"
        local PAGE_URL="$1"
        echo "## Will determine version from website..." >&2
        
        local LATEST_VER
        LATEST_VER="$( \
            wget --user-agent="$USER_AGENT"  "$PAGE_URL" -O - | \
            grep softwareVersion | \
            sed -E 's/.*content="([^"]*)".*/\1/g' | \
            head -n 1 \
        )"

        if [[ "$LATEST_VER" == "" ]] ; then
            echo "## ERROR: Could not determine version via download page." >&2
            return 1
        fi

        echo "## Latest version available: $LATEST_VER" >&2
        if [[ "$LATEST_VER" == "" ]] ; then
            echo "## ERROR: could not determine latest version." >&2
            return 2
        fi

        echo "$LATEST_VER"
    }

    echo "## Will check latest verison at $PAGE_URL" >&2
    echo "## Checking..." >&2
    NEW_VER="$(GetLatestVer "$PAGE_URL")" || return $?

    if [[ "$NEW_VER" != "" ]] ; then
        echo "$NEW_VER"
        return 0
    fi

    echo "## ERROR: No version specified." >&2
    Usage
    return 3
}

function UpdateProg() {
    local MANUAL_VER="$1"
    local EXT="$2"
    local NAME="$3"
    local PROG_DIR="$4"
    local DWN="${PROG_DIR}/../downloads/"
    
    local PAGE_URL="$(echo "$5" | sed "s/\\\${NAME}/$NAME/g")"
    local VER
    VER="$(GetVer "$PAGE_URL" "$MANUAL_VER")" || return $?
    echo "VER: $VER"
    
    local FILE="${NAME}-${VER}.${EXT}"
    local FILE_URL="$(echo "$6" | sed "s/\\\${FILE}/$FILE/g" )"
    FILE_URL="$(echo "$FILE_URL" | sed "s/\\\${VER}/$VER/g" )"

    local TAG_FILE="${DWN}/${NAME}_installed.${VER}"
    local TARGET="${DWN}/${NAME}-${VER}.${EXT}"

    if [ -e "$TAG_FILE" ] ; then
        echo "## DONE: This version already installed. Aborting. To force a reinstall, please delete $TAG_FILE" >&2
        return 0
    fi
    
    DownloadFile "$FILE_URL" "$TARGET" || return $?

    if [ -d "${PROG_DIR}" ] ; then
        echo "## Removing old version..." >&2
        rm -rf 2>/dev/null "$PROG_DIR"
    fi
    echo "## Extracting package..." >&2
    echo "   tar xavf \"$TARGET\" -C \"${PROG_DIR}\"/../" >&2
    tar xavf "$TARGET" -C "${PROG_DIR}"/../

    echo "## Updating tag file..." >&2
    touch "$TAG_FILE"
    echo "## Done" >&2
    exit 0
}

function go() {
    local NAME="thunderbird"
    local PROG_DIR="/opt/${NAME}"
    local PAGE_URL='https://www.${NAME}.net/en-US/'
    local FILE_URL="https://download-installer.cdn.mozilla.net/pub/${NAME}/releases/\${VER}/linux-x86_64/en-US/\${FILE}"
    
    local ALL_EXT=("tar.bz2" "tar.xz")
    local EXT

    for EXT in "${ALL_EXT[@]}" ; do
        echo "## Attempting download of $EXT file..." >&2
        UpdateProg "$1" "$EXT" "$NAME" "$PROG_DIR" "$PAGE_URL" "$FILE_URL"  && break
    done 2>&1 | tee "/tmp/update_${NAME}.log"
}

go "${@}"

