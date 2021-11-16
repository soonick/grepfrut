<img src="https://github.com/soonick/grepfrut/blob/master/media/grapefruit.svg" align="left" height="100" width="100">

# Grepfrut

Grepfrut is a Vim plugin to search for a string on multiple files (`grep`). Just use the `Gf` command followed by the string to search:

```
:Gf blue car
```

To do a case insensitive search:

```
:Gfi blue car
```

## Configurations

To make Grepfrut always ignore some files, use the `g:grepfrut_global_exclude` option:

```
let g:grepfrut_global_exclude = '.*(node_modules|\.next|\.git).*'
```
