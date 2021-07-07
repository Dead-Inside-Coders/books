MAINBRANCH="main"
EXTENTIONS=("_current" "_dev")
ALL_BRANCHES=$(git show-ref --heads | sed 's/.*refs\/heads\///')

merged_branches=()

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
		merged_branches+=($branch)
	else 
		echo "Error: $branch is not merged"
		
 	fi
 fi
done


for checked_branch in ${merged_branches[@]}; do
	is_task_branch_deleted=false
	for extention in ${EXTENTIONS[@]}; do
		if [[ "$checked_branch" == *"$extention"* ]]; 
		then
			git branch -d $checked_branch
			if ! $is_task_branch_deleted 
			then
				end_index=$((${#checked_branch}-${#extention}))
				git branch -d ${checked_branch:0:$end_index}
			fi 		
		fi
		is_task_branch_deleted=true
	done
done
read -p "Press Enter to continue ..." 

