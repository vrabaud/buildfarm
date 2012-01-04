assert_set ()
{
    for VAR in $* ; do
        /bin/echo -n "Checking $VAR..."
        if [ -z "${!VAR}" ] ; then
            /bin/echo "UNSET"
            ERR="y"
        else
            /bin/echo " = '${!VAR}'"
        fi
    done
    [ -n "$ERR" ] && exit 1
}
