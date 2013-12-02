## QUICK HOWTO

How to add mql4 syntax file into your vim configuration:

### Traditional way

First, clone this repository to your local.

```
$ cd ~/.vim/
$ git clone https://github.com/vobornik/vim-mql4.git
```

It's also ok that download zip file and extract that.

Then, open your `.vimrc` file and write a following line to add it to runtimepath.

```
set runtimepath+=expand('~/.vim/vim-mql4')
```

### Modern way

I recommend to use plugin-manager plugin like `NeoBundle` or `Vundle`.


## You might be interested in...

You might be interested in "auto pilot" trading at http://copytrade.zulutrade.com/ - just copy trades from the best performed traders into your trading platform and earn money

