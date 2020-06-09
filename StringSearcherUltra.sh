#!/bin/bash

# Configuration /
directoriesToParse=(
		"/home/user/directory/one"
		"/home/m/user/director/two"
	) # Modify to add more items to the directory array. Ex: directories=("one" "two" "three")

# Key Files
keyListFile="theseKeys.txt"; # File holding a list of All Current Keys, Seperated on new lines
addSpecialKeys="addSpecialKeys.txt" # Regex: "\#.*" Other extra keys that can get added into consideration.

# Main Defaults
isDefaultFileNames="yes"; # Using default names initialized below
foundItemsFile="found";
unfoundItemsFile="notFound";

outputFilesDir="output"; # Output file directory
combinedAllDir="all" # Combined output file directory

joinedKeysFile="MergedKeys.txt";
allUnfoundFile="AllUnfound.txt" # Combined Unfound file
allFoundFile="AllFound.txt" # Combined Found file

# Terminal Colours
PURPLE='\033[0;35m';
GREEN='\033[0;32m';
GRAY='\033[0;37m';
BLUE='\033[0;34m';
RED='\033[0;31m';
NC='\033[0m';

printConfig(){
	echo "";
	if [ "$isDefaultFileNames" == "yes" ]
		then
			echo -e "    ${BLUE}Output Names:${NC} Default";
		else
			echo -e "    ${BLUE}Output Names:${NC} Custom";
	fi
	echo -e "    ${BLUE}KeyFile:${NC} $keyListFile";
	echo -e "    ${BLUE}SpecialKeysFile:${NC} $addSpecialKeys";
	echo -e "    ${BLUE}Directories to parse: ${NC} ${#directoriesToParse[@]} ";
	for i in "${directoriesToParse[@]}"; do
  		echo -e "    $i";
	done
	echo "";
}

# Begin Program
echo -e "\n     ${RED}/ ${GREEN} String Searcher Ultra ${RED}\\";
printConfig
echo -e "    ${GREEN}If the above looks correct, press ${RED}ENTER${GREEN}${NC}";
read newTempVar

if [ -d "$outputFilesDir" ]; then
	echo -e "${BLUE}Old Output folder exists with files:${NC}";
	cd "$outputFilesDir";
	ls;
	echo -e "${GREEN}Press ${RED}ENTER${GREEN} to delete old outputs: (${BLUE}CONTROL+C${NC} to Cancel)${NC}"; read newTempVar;
	rm *.txt;
	if [ -d "$combinedAllDir" ]; then
		echo -e "${BLUE}Old All folder exists with files:${NC}";
		cd "$combinedAllDir"; ls;
		echo -e "${GREEN}Press ${RED}ENTER${GREEN} to delete All folder items: (${BLUE}CONTROL+C${NC} to Cancel)"; read newTempVar;
		rm *.txt;
		cd "..";
		rmdir "$combinedAllDir";
	fi
	cd "..";
	rmdir "$outputFilesDir";
  # Control will enter here if $DIRECTORY exists.
fi


# Custom Optional Filenames
if [ "$isDefaultFileNames" != "yes" ]; then
	read -p "Please name the Found Items File(s): " foundItemsFile;
	read -p "Please name the Not-Found Items File: " unfoundItemsFile;	
	read -p "Press any key to start..." newTempVar;	
fi

# Running Main Process
mainProcess(){

	mkdir $outputFilesDir;
	echo -e "${GRAY}Process Started${NC}";
	echo -e "${GRAY}*******************************************************************${NC}";

	echo -e "${BLUE}Build Joined Keys File for Extra Checking:${NC} $joinedKeysFile\n";
	touch "$outputFilesDir/$joinedKeysFile";
	
	cat "$keyListFile" >> "$outputFilesDir/$joinedKeysFile";
	cat "$addSpecialKeys" >> "$outputFilesDir/$joinedKeysFile";

	echo -e "${BLUE}Filtering on:${NC}"
	for i in "${!directoriesToParse[@]}"; do 
		echo -e "${GRAY} $i ${NC}    ${directoriesToParse[$i]}"
		foundItemsResult=`grep -f "$keyListFile" -R ${directoriesToParse[$i]}  -o > "$outputFilesDir/$foundItemsFile$i.txt"`
		nextFinalRes=`grep -oFf "$keyListFile" "$outputFilesDir/$foundItemsFile$i.txt" | grep -vFf - "$keyListFile" > "$outputFilesDir/$unfoundItemsFile$i.txt"`
	done


	echo -e "\n${BLUE}Combining All:${NC}"; cd "$outputFilesDir";
	mkdir "$combinedAllDir"; touch "$allFoundFile";
	
	for i in "${!directoriesToParse[@]}"; do 
		echo -e "${GRAY} $i ${NC}    ${directoriesToParse[$i]}"
		cat "$foundItemsFile$i.txt" >> "$allFoundFile";
	done

	echo -e "\n${BLUE}Adding Special Keys to be considered as 'Found'.${NC}";
	cat "../$addSpecialKeys" >> "$allFoundFile";

	echo -e "\n${BLUE}Combining Completed.${NC}";
	combinedFileRes=`grep -oFf "../$keyListFile" "$allFoundFile" | grep -vFf - "../$keyListFile" > "$allUnfoundFile"`
	mv "$allFoundFile" "$combinedAllDir"; mv "$allUnfoundFile" "$combinedAllDir"


	echo -e "${GRAY}*******************************************************************";
	echo -e "${GRAY}Process Complete!${NC}\n";

}
mainProcess
