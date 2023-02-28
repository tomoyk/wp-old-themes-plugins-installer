#!/bin/bash 

response=$(curl -sL https://wordpress.org/themes/ | grep "var _wpThemeSettings" | sed -e 's/var _wpThemeSettings = //g' -e 's/;$//g')

echo $response | jq -r '.query.themes[].slug' | while read theme_slug
do
    echo $theme_slug
    versions=$(curl -s "https://themes.trac.wordpress.org/log/${theme_slug}?limit=10&mode=stop_on_copy&format=rss" | grep title | grep -o "\([0-9]\+\.\)\+[0-9]\+")
    for ver in $versions
    do
        wget https://downloads.wordpress.org/theme/${theme_slug}.${ver}.zip
    done
done
