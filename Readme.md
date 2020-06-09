# String Searcher Ultra 

This bash script uses grep, and can search through multiple directories to find any instance of strings from a list.
It will return files with words that were found, and files for words that were not-found, as well as Overall joined Found and Not-found lists of words. This script can be used for optimization purposes.

Special Keys for particular work flows can be added to addSpecialKeys.txt file before running.

### Prerequisites

```
grep
```

### Installing

Clone this repository
```
git clone ...
```

Change directory into the new cloned repository
```
cd ...
```

Make the script executable
```
chmod +x StringSearcherUltra.sh
```

### Recommended before Running

Edit `theseKeys.txt` and `addSpecialKeys.txt` with desired query strings. These will be joined together when running the script, to give more accurate results for redundant strings.


### Running the StringSearcherUltra

Only required to set your directories in the Configuration at the top of the script.
```
directoriesToParse=("one/somewhere" "two/elsewhere" "three/inside")
```

Run the program, and follow the prompts.
```
./StringSearcherUltra.sh
```

### Built With

* [Bash](https://www.gnu.org/software/bash/) - Bash
* [Grep](https://en.wikipedia.org/wiki/Grep) - Grep
