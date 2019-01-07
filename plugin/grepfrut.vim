" Define the grepfrut command
command! -nargs=1 Gf call s:Grepfrut(<f-args>)

" Entry point for the plugin
" search_string is the string we are going to grep for
function s:Grepfrut(search_string)
  " Ask user which directory they want to search
  let cwd = getcwd()
  let search_dir = input("Start searching from directory: ", cwd, "dir")

  " Which files to search
  let search_files = input("Search files matching pattern (Empty will match all): ")

  " Which files to not search
  let exclude_files = input("Exclude files matching pattern (Empty will not exclude any file): ")

  " Run the command
  echo "\r"
  let cmd = s:BuildGrepCommand(a:search_string, search_dir, search_files, exclude_files)
  call s:RunCommand(cmd)
endfunction

" Builds the command to grep for the search_string in all files
" search_string - The string we are searching for
" dir - The directory where the search will start
" include_files - Only files in `dir` matching this pattern will be grepped. If
"                 include_files is empty, all files will be grepped
" exclude_files - Files matching this pattern will not be grepped. If empty, all
"                 files will be grepped
function s:BuildGrepCommand(search_string, dir, include_files, exclude_files)
  let cmd = "find " . a:dir . " -type f "

  if a:include_files != ""
    let cmd = cmd . " | grep \"" . a:include_files . "\""
  endif

  if a:exclude_files != ""
    let cmd = cmd . " | grep -v \"" . a:exclude_files . "\""
  endif

  let cmd = cmd . " | xargs grep -n \"" . a:search_string . "\""

  return cmd
endfunction

" Run the command and show results in quickfix
" cmd - The grep command that will be exuted
function s:RunCommand(cmd)
  let cmd_output = system(a:cmd)

  " Open the output in a quickfix window
  caddexpr cmd_output
  copen
endfunction
