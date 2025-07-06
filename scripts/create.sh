#!/usr/bin/env bash

set -e

# Check for gum
if ! command -v gum &>/dev/null; then
    echo "Error: gum is not installed. Please install it from https://github.com/charmbracelet/gum"
    exit 1
fi

# Select content type
type=$(gum choose --header="Select content type" blog bookmarks notes projects experience)

# Get common fields
title=$(gum input --placeholder "Title")
slug=$(gum input --placeholder "Slug (file name, no spaces)")
description=$(gum input --placeholder "Description")

today=$(date +%F)

# Helpers
get_tags() {
    gum input --placeholder "Comma-separated tags (tag1,tag2)"
}

get_bool() {
    gum choose "true" "false"
}

get_date() {
    gum input --placeholder "YYYY-MM-DD" --value "$today"
}

get_array() {
    gum input --placeholder "Comma-separated list (item1,item2)"
}

# Output path
outdir="./src/content/$type"
outfile="$outdir/$slug.md"
mkdir -p "$outdir"

# Build frontmatter
case "$type" in
blog)
    publishedAt=$(get_date)
    tags=$(get_tags)
    frontmatter="---
title: '$title'
description: '$description'
publishedAt: $publishedAt
tags: [$(echo "$tags" | sed "s/,/','/g" | sed "s/^/'/" | sed "s/$/'/")]
---"
    ;;

bookmarks)
    author=$(gum input --placeholder "Author")
    url=$(gum input --placeholder "URL")
    publishedAt=$(get_date)
    createdAt=$(get_date)
    typeField=$(gum input --placeholder "Type (e.g. article, video)")
    frontmatter="---
title: '$title'
type: '$typeField'
author: '$author'
url: '$url'
publishedAt: $publishedAt
createdAt: $createdAt
description: '$description'
---"
    ;;

notes)
    publishedAt=$(get_date)
    category=$(gum input --placeholder "Category")
    frontmatter="---
title: '$title'
description: '$description'
publishedAt: $publishedAt
category: '$category'
---"
    ;;

projects)
    url=$(gum input --placeholder "Project URL")
    featured=$(get_bool)
    techs=$(get_array)
    frontmatter="---
title: '$title'
description: '$description'
url: '$url'
featured: $featured
techs: [$(echo "$techs" | sed "s/,/','/g" | sed "s/^/'/" | sed "s/$/'/")]
---"
    ;;

experience)
    logo=$(gum input --placeholder "Logo path (e.g. /logos/foo.png)")
    startDate=$(get_date)
    current=$(get_bool)
    frontmatter="---
title: '$title'
logo: '$logo'
description: '$description'
startDate: '$startDate'
current: $current
---"
    ;;
esac

# Get content if applicable
if [[ "$type" != "bookmarks" && "$type" != "experience" && "$type" != "projects" ]]; then
    content=$(gum write --placeholder "Write content for the template")
else
    content=""
fi

# Write file
echo "$frontmatter" >"$outfile"
echo "" >>"$outfile"
echo "$content" >>"$outfile"

gum style --border double --padding "1 2" --margin "1" --foreground 212 "Created $outfile"
