for x in $(luaotfload-tool --list=* --fields=fullpath); do
    luatex -interaction=nonstopmode "\\relax\\input luaotfload.sty \\font\\x[$x]\\bye" > /dev/null
done
