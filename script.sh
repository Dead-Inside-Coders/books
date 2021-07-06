MAINBRANCH="main"
EXTENTIONS=("_current" "_dev")

is_merged_to_master() {
    for merged_branch in $(git for-each-ref --merged=origin/$MAINBRANCH --format="%(refname:short)" refs/heads/); do
		if [[ "$merged_branch" == "$1" ]]; then
			true
			return
		fi
	done
	false 
	return
}

for branch in $(git show-ref --heads | sed 's/.*refs\/heads\///'); do
 if [[ "$branch" != "$MAINBRANCH" ]] 
 then
    if is_merged_to_master "$branch" 
	then
		echo "$branch: OK"
	else 
		echo "Error: $branch is not merged"
		#exit 1
 	fi
	echo "All branches are merged to master!"
	for extention in ${EXTENTIONS[@]}; do
		if [ "$branch" == *"$extention"* ]; 
		then
			#git branch -d $branch
			echo "$branch successfully deleted!"
		fi
	done
 fi
done
read -p "Press Enter to continue ..." 

