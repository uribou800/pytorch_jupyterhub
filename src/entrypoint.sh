echo "change user_id"

usermod -u $USER_ID -o -m developer
groupmod -g $GROUP_ID developer