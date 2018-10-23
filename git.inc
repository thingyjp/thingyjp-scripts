git_init () {
    {
        git -C $2 init
        git -C $2 config user.email "$1"
        git -C $2 config user.name "$1"
        git -C $2 add -A
        git -C $2 commit --allow-empty -a -m "create pki"
    } &>> $LOGFILE
}

git_stamp () {
    REPO=$1
    MSG=$2
    {
        git -C $REPO add -A
        git -C $REPO commit --allow-empty -a -m "$MSG"
    } &>> $LOGFILE
}

git_abort () {
    REPO=$1
    git -C $REPO reset HEAD^ &>> $LOGFILE
}
