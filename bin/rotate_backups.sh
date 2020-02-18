#!/usr/bin/env sh
# Keep NUM_BACKUPS backups only. Otherwise things get cray.

# Take backup count from user input.
# WARNING you will hose your backups if you send a non-integer.
NUM_BACKUPS="${1}"

# Default value if no user input
if [ -z "${NUM_BACKUPS}" -o "${NUM_BACKUPS}" -lt 0 ]; then
  NUM_BACKUPS=5
fi

cd backup

for DOC in $(ls | awk 'BEGIN{FS="."}{print $1}' | uniq); do
  SEARCH="${DOC}*.html" 
  COUNT=$(ls ${SEARCH} | wc -l)
  EXTRA=$(awk "BEGIN{printf ${COUNT}-${NUM_BACKUPS}}")
  # Only zip things up if the number of backups is high enough
  if [ "${EXTRA}" -gt 0 ]; then
    TAR="${DOC}.$(date +'%s').tar"
    # create a tar from a single file (otherwise the append will barf)
    find . -iname "${SEARCH}" -print | head -n 1 | xargs tar -cvf "${TAR}"
    # append to the tar
    find . -iname "${SEARCH}" -print | head -n "${EXTRA}" | xargs tar -rvf "${TAR}"
    # gzip the tar
    gzip "${TAR}"
    # remove the files
    find . -iname "${SEARCH}" -print | head -n "${EXTRA}" | xargs rm
  fi
done
