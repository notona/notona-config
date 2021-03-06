#!/bin/bash

cd `dirname $0`
set -ux pipefail

chsh -s /bin/zsh

cp -r ./home/local ~/
mkdir -vp ~/project
#mkdir -vp ~/work
#mkdir -vp ~/free
mkdir -vp ~/ext
mkdir -vp ~/tmp
mkdir -vp ~/tmp/vim
mkdir -vp ~/tmp/vim/swap

mkdir -p ~/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
git clone https://github.com/Shougo/vimproc.vim ~/.vim/bundle/vimproc

ROOT_DIR=`pwd`
ln -sfn ${ROOT_DIR}/home/vimrc ~/.vimrc
ln -sfn ${ROOT_DIR}/home/globalrc ~/.globalrc
ln -sfn ${ROOT_DIR}/home/zshrc ~/.zshrc
ln -sfn ${ROOT_DIR}/home/tmux.conf ~/.tmux.conf
ln -sfn ${ROOT_DIR}/home/gitconfig ~/.gitconfig

# install vimproc
# NeoBundleInstall の前に実行しないとエラーになる
(
  cd ~/.vim/bundle/vimproc
  case ${OSTYPE} in
    cygwin*)
      make -f make_cygwin.mak
      ;;
    msys*)
      mingw32-make -f make_mingw64.mak
      ;;
    linux*)
      make
      ;;
    darwin*)
      make
      ;;
  esac
)

vim -c NeoBundleInstall! -c ":q" -c ":q"

# ag はマルチバイトに対応していないので
# pt をインストールする
# http://blog.monochromegane.com/blog/2014/01/16/the-platinum-searcher/
case ${OSTYPE} in
  cygwin*)
    cp pt/pt.exe ~/local/bin/
    ;;
  linux*)
    cp pt/pt_linux_x64 ~/local/bin/pt
    ;;
  darwin*)
    cp pt/pt_maxosx_64 ~/local/bin/pt
    ;;
esac
