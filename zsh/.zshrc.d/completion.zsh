# Extra completion tweaks layered on top of slimzsh's completion.zsh.

# Group completion candidates under labeled headers instead of one flat list
# (e.g. separates "targets" from "variables" from "files" for `make`).
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '%F{blue}%B-- %d --%b%f'
zstyle ':completion:*' verbose yes

# make: only suggest real targets/variables, skip the filename/directory
# fallback that clutters the menu with everything in the cwd.
zstyle ':completion:*:make:*' tag-order 'targets variables'
