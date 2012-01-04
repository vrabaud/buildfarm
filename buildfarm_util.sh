assert_set ()
{
    for var in $* ; do
        if [ -z "${!VAR}" ] ; then
            /bin/echo "$VAR not set"
            exit 1
        else
            /bin/echo "  $VAR = '${!VAR}'"
        fi
    done
}
