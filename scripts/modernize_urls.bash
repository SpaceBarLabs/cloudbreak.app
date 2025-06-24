#!/bin/bash
#
# This script replaces hardcoded 'https://cloudbreak.app' URLs with the
# Jekyll variable '{{ site.url }}' to make the site more portable.

# --- Configuration ---
# The URL to be replaced
OLD_URL="https://cloudbreak.app"
# The Jekyll variable to replace it with.
# Note: We use {{ site.url | a }| raw }} to prevent double-escaping in some contexts,
# but for simple replacement, "{{ site.url }}" is safer. We will stick with the simpler version.
NEW_URL="{{ site.url }}"
# The directory to search in. '.' means the current directory.
SEARCH_DIR="."
# Directory to exclude from the search.
EXCLUDE_DIR="./_site"

# --- Script Body ---
echo "Starting URL replacement..."
echo "Replacing '${OLD_URL}' with '${NEW_URL}'"
echo "----------------------------------------"

# Use find to locate relevant files and then use sed to replace the text in-place.
# - We search for .html, .md, .yml, .xml, and .txt files.
# - We exclude the _site directory to avoid changing the generated site.
# - We use xargs to pass the file list to sed.
# - sed -i performs an in-place edit of the files.
# - The 's#...#...#g' syntax uses '#' as a delimiter to avoid issues with slashes in the URL.

find "${SEARCH_DIR}" -type f \( -name "*.html" -o -name "*.md" -o -name "*.yml" -o -name "*.xml" -o -name "*.txt" \) -not -path "${EXCLUDE_DIR}/*" -print0 | xargs -0 sed -i "s#${OLD_URL}#${NEW_URL}#g"

echo "----------------------------------------"
echo "Replacement complete."
echo "Please review the changes with 'git status' or 'git diff'."

