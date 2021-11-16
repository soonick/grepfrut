" Define the grepfrut command
command! -nargs=1 Gf call s:Grepfrut(<f-args>, 1)
command! -nargs=1 Gfi call s:Grepfrut(<f-args>, 0)

" Entry point for the plugin
" search_string is the string we are going to grep for
function s:Grepfrut(search_string, case_sensitive)
  " Ask user which directory they want to search
  let cwd = getcwd()
  let search_dir = input("Start searching from directory: ", cwd, "dir")

  " Which files to search
  let search_files = input("Search files matching pattern (Empty will match all): ")

  " Which files to not search
  let exclude_files = input("Exclude files matching pattern (Empty will not exclude any file): ")

  " Run the command
  echo "\r"
  let cmd = s:BuildGrepCommand(a:search_string, search_dir, search_files, exclude_files, a:case_sensitive)
  call s:RunCommand(cmd)
endfunction

" Builds the command to grep for the search_string in all files
" search_string - The string we are searching for
" dir - The directory where the search will start
" include_files - Only files in `dir` matching this pattern will be grepped. If
"                 include_files is empty, all files will be grepped
" exclude_files - Files matching this pattern will not be grepped. If empty, all
"                 files will be grepped
" case_sensitive - Weather we are doing a case sensitive match or not
function s:BuildGrepCommand(search_string, dir, include_files, exclude_files, case_sensitive)
  let cmd = "find " . a:dir . " -type f "

  let global_exclude = get(g:, 'grepfrut_global_exclude', "")
  if global_exclude != ""
    " This command basically means: find all files in a:dir, except for the ones
    " That match global_exclude regex
    let cmd = "find " . a:dir . " -type d \\( -regextype posix-extended -regex \"" . global_exclude . "\" \\) -prune -o -print"
  endif

  if a:include_files != ""
    let cmd = cmd . " | grep \"" . a:include_files . "\""
  endif

  if a:exclude_files != ""
    let cmd = cmd . " | grep -v \"" . a:exclude_files . "\""
  endif

  if a:case_sensitive == 1
    let cmd = cmd . " | xargs grep -n \"" . a:search_string . "\" 2>1"
  else
    let cmd = cmd . " | xargs grep -n -i \"" . a:search_string . "\" 2>1"
  endif

  return cmd
endfunction

" Run the command and show results in quickfix
" cmd - The grep command that will be exuted
function s:RunCommand(cmd)
  let cmd_output = system(a:cmd)

  " Open the output in a quickfix window
  cgetexpr cmd_output
  copen
endfunction
