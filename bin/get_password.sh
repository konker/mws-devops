#!/bin/sh

TARGET=~/devops/puppet/modules/system/manifests/secrets.pp

if [ -z "$1" ]; then
    echo "Please specify user"
    exit 2
fi

echo "Enter a password for user $1:"
read PASS1
echo "Re-enter password:"
read PASS2

if [ $PASS1 != $PASS2 ]; then
    echo "Passwords do not match. Aborting"
    exit 1
fi

cat<<EOF > $TARGET
class system::secrets {
    \$password1 = '$PASS1'
}
EOF
