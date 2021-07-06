MAINBRANCH="main"
EXTENTIONS=("_current" "_dev")
ALL_BRANCHES=$(git show-ref --heads | sed 's/.*refs\/heads\///')

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

for branch in $ALL_BRANCHES; do
 if [[ "$branch" != "$MAINBRANCH" ]] 
 then
    if is_merged_to_master "$branch" 
	then
		echo "$branch: Merged"
	else 
		echo "Error: $branch is not merged"
		exit 1
 	fi
 fi
done

echo "All branches are merged to master!"

for checked_branch in $ALL_BRANCHES; do
 if [[ "$checked_branch" != "$MAINBRANCH" ]] 
 then
	is_task_branch_deleted=false
	for extention in ${EXTENTIONS[@]}; do
		if [[ "$checked_branch" == *"$extention"* ]]; 
		then
			git branch -d $branch
			echo "$checked_branch successfully deleted!"
			if ! $is_task_branch_deleted 
			then
				end_index=$((${#checked_branch}-${#extention}))
				git branch -d ${checked_branch:0:$end_index}
				echo "${checked_branch:0:$end_index} successfully deleted!"
			fi 		
		fi
		is_task_branch_deleted=true
	done
 fi
done
read -p "Press Enter to continue ..." 

