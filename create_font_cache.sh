for x in $(luaotfload-tool --list=* --fields=fullpath); do \
    /bin/echo "\\relax\\input luaotfload.sty \\font\\x[$x]\\bye" | luatex > /dev/null; \
done
