MAINBRANCH="main"
EXTENTIONS=("_current" "_dev")
REMOTE_DELETE_FLAG="-r"
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

delete_local_branch() {
	echo "delete $1 locally!"
	#git branch -d $1
}

delete_remote_branch() {
	echo "delete $1 remotely!"
	#git push origin --delete $1
}


for branch in $ALL_BRANCHES; do
 if [[ "$branch" != "$MAINBRANCH" ]] 
 then
    if is_merged_to_master "$branch" 
	then
		echo "$branch: Merged"
		merged_branches+=($branch)
	else 
		echo "$branch is not merged"
 	fi 
 fi
done

for checked_branch in ${merged_branches[@]}; do
	is_task_branch_deleted=false
	for extention in ${EXTENTIONS[@]}; do
		if [[ "$checked_branch" == *"$extention"* ]]; 
		then

			if test "$1" = $REMOTE_DELETE_FLAG
			then
				delete_local_branch $checked_branch
				delete_remote_branch $checked_branch
			else
				delete_local_branch $checked_branch
			fi
			
			if ! $is_task_branch_deleted 
			then
				end_index=$((${#checked_branch}-${#extention}))

				if test "$1" = $REMOTE_DELETE_FLAG
				then
					if is_merged_to_master "${checked_branch:0:$end_index}" 
					then
						delete_local_branch ${checked_branch:0:$end_index}
						delete_remote_branch ${checked_branch:0:$end_index}
					fi 	
				else
					if is_merged_to_master "${checked_branch:0:$end_index}" 
					then
						delete_local_branch ${checked_branch:0:$end_index}
					fi
				fi
			fi 		
		fi
		is_task_branch_deleted=true
	done
done
read -p "Press Enter to continue ..." 

