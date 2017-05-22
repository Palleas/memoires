modified_code = git.modified_files.include? "Memoires/*.swift"
updated_release_notes = git.modified_files.include? "buddybuild_release_notes.txt"

fail "You forgot to update the release_notes_file ([docs](http://docs.buddybuild.com/docs/focus-message))" if modified_code && !updated_release_notes

warn "Modification of the post clone step detected!" if git.modified_files.include? "buddybuild_postclone.sh"
