BASEDIR=$(cd `dirname $0` && pwd);
IGNORE=". \
    .. \
    .git \
    .gitignore \
    README.md \
    install.sh"

function create_link() {
    echo "> $2"
    # skip if already a symlink pointing to the correct source
    if [ -L "$2" ] && [ "$(readlink "$2")" = "$1" ]; then
        echo "already linked, skipping";
        return
    fi
    # backup if exists (regular file, directory, or wrong symlink)
    if [ -e "$2" ] || [ -L "$2" ]; then
        echo "exists, backing up";
        mv "$2" "$2-$(date '+%Y-%m-%d-%H:%M:%S')";
    fi
    # link
    echo "linking from $1\n";
    ln -s "$1" "$2"
}


for FILEPATH in $(find $BASEDIR -name "*" -not -path "$BASEDIR/.git/*"); do
    # skip all directory
    if [[ -d $FILEPATH ]]; then
        continue;
    fi

    DIR=$(dirname $FILEPATH);
    FILE=$(basename $FILEPATH);
    REALTIVE_PATH="${DIR/#$BASEDIR/}";

    # if current file in root dir
    if [ -z $REALTIVE_PATH ]; then
        # skip ignored file
        if ! echo $IGNORE | grep -v -q $FILE; then
            continue
        fi

        create_link $BASEDIR/$FILE ~/$FILE
        continue
    fi

    # for file not in root dir, link dir contains .root file
    if [ $FILE != ".root" ]; then
        continue
    fi
    REALTIVE_PATH="${REALTIVE_PATH/\//}"
    mkdir -p $DIR
    create_link $BASEDIR/$REALTIVE_PATH ~/$REALTIVE_PATH
done
