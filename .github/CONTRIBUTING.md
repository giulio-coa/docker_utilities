# How to Contribute
For contribute at this project, open an Issue or a Pull request.

### Rules to Code

* For indentation, use Tabs instead Spaces
* For the strings delimiter, use `'` except for the formatting character (`"\n"`, `"\t"`, etc.) or for the string that contains variables
* Every special character must be preceed by a `\` (_i.e._ use `"\'"` instead of `"'"`)
* If you want insert a variable into a string, surround it with brackets (_i.e._ use `"${var}/iable"` instead of `"$var/iable"`)
* Each statement doesn't have to be on one line (_i.e._ don't use `if [ ... ]; then`, insert a new line instead of the semicolon)
```
if [ ... ]
then
```

### Util links

* [How to work with branches](https://www.robinwieruch.de/git-team-workflow)
