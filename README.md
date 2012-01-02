QUICK HOWTO
============

How to add mql4 syntax file into your vim configuration:


    $ mkdir -p ~/.vim/ftdetect
    $ echo 'au BufRead,BufNewFile *.mq4		set filetype=mql4' > ~/.vim/ftdetect/mql4.vim
    $ mkdir -p ~/.vim/syntax 
    $ cd ~/.vim/syntax
    $ wget https://github.com/vobornik/vim-mql4/raw/master/mql4.vim



You might be interested in "auto pilot" trading at http://copytrade.zulutrade.com/ - just copy trades from the best performed traders into your trading platform and earn money

