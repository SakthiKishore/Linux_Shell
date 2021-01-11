while read LINE
do
    USERNAME=$(echo $LINE | cut -d':' -f 1)
    USERID=$(echo $LINE | cut -d':' -f 3)
    echo "The UID of $USERNAME is $USERID"
done < /etc/passwd
