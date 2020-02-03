#!/usr/bin/env bash

set -e
set -o pipefail
set -u
# set -v

DERIVED_DATA='build'
PRODUCTS=${DERIVED_DATA}/Build/Products
OUTPUT=build/namespace/static
SCHEME='libMapboxMobileEvents'
BUILDTYPE=${BUILDTYPE:-Debug}
JOBS=`sysctl -n hw.ncpu`
NAME_PATH=build/namespace/header
NAME_HEADER=${NAME_PATH}/MMENamespacedDependencies.h
PREFIX="MGL"
INFO_PLIST=MapboxMobileEvents/Info.plist

function step { >&2 echo -e "\033[1m\033[36m* [`date +%H:%M:%S`] $@\033[0m"; }
function finish { >&2 echo -en "\033[0m"; }
trap finish EXIT

# This is a modified version of: https://github.com/jverkoey/nimbus/blob/master/scripts/generate_namespace_header
function generate_namespace_header {
    mkdir -p $NAME_PATH && touch $NAME_HEADER

    echo "Generating $NAME_HEADER from $1"
    echo "// This namespaced header is generated.
// Add source files to the libMapboxMobileEvents target, then run \`make name-header\`.

#ifndef __NS_SYMBOL
// We need to have multiple levels of macros here so that __NAMESPACE_PREFIX_ is
// properly replaced by the time we concatenate the namespace prefix.
#define __NS_REWRITE(ns, symbol) ns ## _ ## symbol
#define __NS_BRIDGE(ns, symbol) __NS_REWRITE(ns, symbol)
#define __NS_SYMBOL(symbol) __NS_BRIDGE($PREFIX, symbol)
#endif

    " > $NAME_HEADER

    echo "// Classes" >> $NAME_HEADER
    nm $1 -j | sort | uniq | grep "^_OBJC_CLASS_\$_" \
        | grep -i "\$_MME" \
        | sed -e 's/_OBJC_CLASS_\$_\(.*\)/#ifndef \1\'$'\n''#define \1 __NS_SYMBOL(\1)\'$'\n''#endif\'$'\n''/g' >> $NAME_HEADER

    echo "// Functions"
    echo "// Functions" >> $NAME_HEADER
    
    nm $1 | sort | uniq | grep " T " | cut -d' ' -f3 \
        | grep -i "_mme" \
        | sed -e 's/_\(.*\)/#ifndef \1\'$'\n''#define \1 __NS_SYMBOL(\1)\'$'\n''#endif\'$'\n''/g' >> $NAME_HEADER

    echo "// Externs"
    echo "// Externs" >> $NAME_HEADER
    
    nm $1 | sort | uniq | grep " D " | cut -d' ' -f3 \
        | grep -v "l_OBJC_PROTOCOL" \
        | grep -i "\$_MME" \
        | sed -e 's/_\(.*\)/#ifndef \1\'$'\n''#define \1 __NS_SYMBOL(\1)\'$'\n''#endif\'$'\n''/g' >> $NAME_HEADER

    echo "// Protocols"
    echo "// Protocols" >> $NAME_HEADER

    nm $1 | sort | uniq | grep " D " | cut -d' ' -f3 \
        | grep "__OBJC_PROTOCOL" \
        | grep -i "\$_MME" \
        | sed -e 's/__OBJC_PROTOCOL_\$_\(.*\)/#ifndef \1\'$'\n''#define \1 __NS_SYMBOL(\1)\'$'\n''#endif\'$'\n''/g' >> $NAME_HEADER

    echo "// Constants"
    echo "// Constants" >> $NAME_HEADER

    nm $1 | sort | uniq | grep " S " | cut -d' ' -f3 \
        | grep -v "OBJC_" \
        | grep -i "_MME" \
        | sed -e 's/_\(.*\)/#ifndef \1\'$'\n''#define \1 __NS_SYMBOL(\1)\'$'\n''#endif\'$'\n''/g' >> $NAME_HEADER
}

# Can build iphoneos (device) or iphonesimulator (simulator)
function build() {    
    xcodebuild \
        ONLY_ACTIVE_ARCH=NO \
        -project MapboxMobileEvents.xcodeproj \
        -scheme ${SCHEME} \
        -derivedDataPath ${DERIVED_DATA} \
        -configuration ${BUILDTYPE} \
        -jobs ${JOBS} \
        -sdk $1 build | xcpretty
}

function create_static_library() {
    step "Cleaning build folder"
    rm -rf build/*

    step "Building binary using scheme ${SCHEME} for iphonesimulator"
    build iphonesimulator

    step "Building binary using scheme ${SCHEME} for iphoneos"
    build iphoneos

    step "Creating fat static binary for iphonesimulator iphoneos"
    mkdir -p ${OUTPUT} && touch ${OUTPUT}/libMapboxEvents.a
    libtool -static -no_warning_for_no_symbols -o ${OUTPUT}/libMapboxEvents.a \
        ${PRODUCTS}/${BUILDTYPE}-iphoneos/libMapboxMobileEvents.a \
        ${PRODUCTS}/${BUILDTYPE}-iphonesimulator/libMapboxMobileEvents.a

    step "Copying header files"
    mkdir -p ${OUTPUT}/include/MapboxMobileEvents
    cp MapboxMobileEvents/MMETypes.h ${OUTPUT}/include/MapboxMobileEvents/MMETypes.h
    cp MapboxMobileEvents/MMEConstants.h ${OUTPUT}/include/MapboxMobileEvents/MMEConstants.h
    cp MapboxMobileEvents/MMEEvent.h ${OUTPUT}/include/MapboxMobileEvents/MMEEvent.h
    cp MapboxMobileEvents/MMEEventsManager.h ${OUTPUT}/include/MapboxMobileEvents/MMEEventsManager.h
    cp MapboxMobileEvents/MapboxMobileEvents.h ${OUTPUT}/include/MapboxMobileEvents/MapboxMobileEvents.h

    step "Copying plist"
    cp ./${INFO_PLIST} ${OUTPUT}/Info.plist

    step "Compressing"
    mv build/namespace/static build/namespace/mapbox-events-ios-static
    cd build/namespace
    zip -r mapbox-events-ios-static.zip mapbox-events-ios-static
    cd -
    cp -r build/namespace/mapbox-events-ios-static.zip build/mapbox-events-ios-static.zip 

    step "mapbox-events-ios-static.zip is now available in the build folder"
}

function package_namespace_header() {
    step "Cleaning build folder"
    rm -rf build/*

    step "Building binary using scheme ${SCHEME} for iphonesimulator"
    build iphonesimulator

    step "Generating namespaced header"
    generate_namespace_header $PRODUCTS/${BUILDTYPE}-iphonesimulator/libMapboxMobileEvents.a

    step "Copy namespaced header to project"
    cp $NAME_HEADER MapboxMobileEvents/MMENamespacedDependencies.h
}

function get_current_version_number() {
    currentVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ./${INFO_PLIST})
    echo $currentVersion
}

function tag_version_manual() {
    previousVersionNumber=$(get_current_version_number)

    read  -rep $"This will version with $1 (previous version was $previousVersionNumber); do you want to proceed? (y or n): " REPLY
    if [ "$REPLY" = "y" ]; then
        step "Updating plist and podspec files for version: $1"
        projectPlist="$INFO_PLIST"
        /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $1" $projectPlist
        sed -e "s/$previousVersionNumber/$1/g" MapboxMobileEvents.podspec > temp.podspec && mv temp.podspec MapboxMobileEvents.podspec

        step "Making commit for version: $1"
        git commit -am "Update version to $1"

        step "Making local git tag for version: $1"
        git tag "v$1"

        read  -rep $"Do you want to push the commit and tag for $1 to GitHub? (y or n): " REPLY_PUSH
        if [ "$REPLY_PUSH" = "y" ]; then
            git push origin head
            git push origin "v$1"
        else
            read  -rep $"Do you want to revert the local commit and tag for $1? (y or n): " REPLY_REVERT
            if [ "$REPLY_REVERT" = "y" ]; then
                git reset --hard head~1
                git tag -d "v$1"
            fi                   
        fi
    fi
}

while getopts ":hsvt:" opt; do
  case ${opt} in
    h) 
      package_namespace_header
      ;;
    s)
      create_static_library
      ;;
    v) 
      get_current_version_number
      ;;
    t)
      tag_version_manual $OPTARG      
      ;;
    \?) echo "Usage: package [-h]"
      ;;
  esac
done
