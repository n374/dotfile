BASEDIR=$(cd `dirname $0` && pwd);
[ ! -f ~/.vimrc ] || mv ~/.vimrc ~/.vimrc-`date +%s`;
[ ! -f ~/.zshrc ] || mv ~/.zshrc ~/.zshrc-`date +%s`;
[ ! -f ~/.tmux.conf ] || mv ~/.tmux.conf ~/.tmux.conf-`date +%s`;
[ ! -f ~/.ideavimrc ] || mv ~/.ideavimrc ~/.ideavimrc-`date +%s`;

ln -s $BASEDIR/.vimrc ~/.vimrc;
ln -s $BASEDIR/.tmux.conf ~/.tmux.conf;
ln -s $BASEDIR/.zshrc ~/.zshrc;
ln -s $BASEDIR/.ideavimrc ~/.ideavimrc;
