#!/bin/bash

# This script converts Jekyll index.html files in subdirectories into
# top-level files with a permalink in the frontmatter.
# For example, a file at "service/index.html" will be converted to
# "service.html" in the root directory, and the frontmatter will be updated
# to include "permalink: /service/".
#
# It also handles nested directories, like "service/faq/index.html", which
# will become "service-faq.html" with "permalink: /service/faq/".
#
# The script creates new files and does not modify or delete the original
# files or directories. You can review the generated .html files to ensure
# they are correct before removing the old structure.

find . -mindepth 2 -type f -name "index.html" -not -path "./_site/*" | while read -r file; do
    dir=$(dirname "$file")
    
    # Construct the permalink and new filename
    path_from_root="${dir#./}"
    permalink="/${path_from_root}/"
    new_filename=$(echo "$path_from_root" | tr '/' '-').html

    echo "Converting ${file} to ${new_filename}"

    # Use awk to create the new file with the added permalink
    # This handles files with or without existing frontmatter
    awk -v permalink="$permalink" '
    BEGIN {
        in_frontmatter = 0
        frontmatter_written = 0
    }
    # Handle files that start with frontmatter
    NR == 1 && /^---$/ {
        print
        in_frontmatter = 1
        next
    }
    # Handle files that do not start with frontmatter
    NR == 1 && !/^---$/ {
        print "---"
        print "layout: default"
        print "permalink: " permalink
        print "---"
        print
        frontmatter_written = 1
        next
    }
    # End of frontmatter
    in_frontmatter == 1 && /^---$/ {
        print "permalink: " permalink
        print
        in_frontmatter = 0
        frontmatter_written = 1
        next
    }
    {
        print
    }
    END {
        if (!frontmatter_written) {
             # This case handles an empty file or a file with just "---"
            if (in_frontmatter) {
                print "permalink: " permalink
                print "---"
            } else {
                print "---"
                print "layout: default"
                print "permalink: " permalink
                print "---"
            }
        }
    }
    ' "$file" > "$new_filename"
done

echo "Conversion complete. The new files have been created in the current directory."
