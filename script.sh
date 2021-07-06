MAINBRANCH = "master"

is_merged_to_master() {
    for branch in $(git for-each-ref --merged=origin/$MAINBRANCH --format="%(refname:short)" refs/heads/); do
		if [ "$branch" == "$1" ]; then
			return true; 
		fi
	done
	return false;
}

for branch in $(git show-ref --heads | sed 's/.*refs\/heads\///'); do
 if [ "$branch" != "$MAINBRANCH" ]; then
    
 fi
done

read -p "Press Enter to continue ..." 