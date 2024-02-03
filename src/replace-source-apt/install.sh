#!/bin/sh

# get linux distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo "ID=$ID"
    echo "VERSION_ID=$VERSION_ID"

    case $ID in
        "ubuntu")
            VERSION_NAME=""
            case $VERSION_ID in
                "18.04") VERSION_NAME="bionic" ;;
                "20.04") VERSION_NAME="focal" ;;
                "21.04") VERSION_NAME="hirsute" ;;
                "21.10") VERSION_NAME="impish" ;;
                "22.04") VERSION_NAME="jammy" ;;
                *) VERSION_NAME="unkown" ;;
            esac
            echo "VERSION_NAME=$VERSION_NAME"

            if [ "$VERSION_NAME" = "unknown" ]; then
                echo "unkown version"
                exit 1
            fi
            ;;
        *)
            # Default case
            echo "unsupported distribution"
            exit 1
            ;;
    esac

fi

# Set source for apt using options
BASE_URL=""
case $SOURCE_MIRROR in
    "sjtu")
        BASE_URL="https://mirror.sjtu.edu.cn/ubuntu/"
        ;;
    "ustc")
        BASE_URL="https://mirrors.ustc.edu.cn/ubuntu/"
        ;;
    "tsinghua")
        BASE_URL="https://mirrors.tuna.tsinghua.edu.cn/ubuntu/"
        ;;
    "aliyun")
        BASE_URL="http://mirrors.aliyun.com/ubuntu/"
        ;;
    "163")
        BASE_URL="http://mirrors.163.com/ubuntu/"
        ;;
    *)
        # Default case
        echo "unsupported source mirror"
        exit 1
        ;;
esac


SOURCE_STRING="deb $BASE_URL $VERSION_NAME main restricted universe multiverse \n\
deb $BASE_URL $VERSION_NAME-updates main restricted universe multiverse \n\
deb $BASE_URL $VERSION_NAME-backports main restricted universe multiverse"

if [ "$SOURCE_ENABLED" = "true" ]; then
    SOURCE_STRING="$SOURCE_STRING\n\
deb-src $BASE_URL $VERSION_NAME main restricted universe multiverse \n\
deb-src $BASE_URL $VERSION_NAME-updates main restricted universe multiverse \n\
deb-src $BASE_URL $VERSION_NAME-backports main restricted universe multiverse"
fi

if [ "$SECURITY_FORCE_MIRROR" = "true" ]; then
    SOURCE_STRING="$SOURCE_STRING\n\
deb $BASE_URL $VERSION_NAME-security main restricted universe multiverse"
fi

# if both
if [ "$SOURCE_ENABLED" = "true" ] && [ "$SECURITY_FORCE_MIRROR" = "true" ]; then
    SOURCE_STRING="$SOURCE_STRING\n\
deb-src $BASE_URL $VERSION_NAME-security main restricted universe multiverse"
fi

# check if file exist
if [ -f /etc/apt/sources.list ]; then
    echo "back up /etc/apt/sources.list"
    cp /etc/apt/sources.list /etc/apt/sources.list.bak
fi

# Set source
echo "$SOURCE_STRING" > /etc/apt/sources.list
apt update