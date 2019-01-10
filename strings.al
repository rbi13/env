#!/bin/bash

## String and file manipulations
#
# sed functions combined with ';'
#

alias xclip="xclip -selection c"
sstrip(){ sed "s/$1//g" $2 ;}
sappend(){ sed "s/\$/$1/" $2 ;}
sprepend(){ sed "s/^/$1/" $2 ;}

ssplit(){ python -c "print('$1'.split(':')[$2])" ;}

scol(){ awk "{ print \$$1 }" ;}
scolr(){ awk "{for(i=$1;i<=NF;++i)printf \$i\" \"; print \"\" }" ;}

hist(){ history $1 | scolr 5  | cbcopy ;}

# python - <<END

# python << END
# END
