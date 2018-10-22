git_init () {
	git -C $2 init
	git -C $2 config user.email "$1"
	git -C $2 config user.name "$1"
	git -C $2 add -A
	git -C $2 commit --allow-empty -a -m "create pki"
}

git_stamp () {
    REPO=$2
    MSG=$1
	git -C $REPO add -A
	git -C $REPO commit --allow-empty -a -m "$MSG"
}

git_abort () {
	git -C $1 reset HEAD^
}
