cd $HOME
echo "Work on " `pwd`

# oh-my-zsh
rm -rf $HOME/.oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"; sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# fzf
rm -rf $HOME/.fzf
rm -f $HOME/.fzf.zsh
rm -f $HOME/.fzf.bash
#git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
#$HOME/.fzf/install

# fzf-vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim -c :PlugInstall -c :qa

ln -sfv ~/develconfig/zshrc ~/.oh-my-zsh/custom/ohmyzshrc.zsh 
mkdir -p ~/.oh-my-zsh/custom/themes
ln -sfv ~/develconfig/custom_vcs.zsh-theme ~/.oh-my-zsh/custom/themes/custom_vcs.zsh-theme
sed -i 's/robbyrussell/custom_vcs/g' ~/.zshrc
sed -i 's/^# DISABLE_UNTRACKED_FILES_DIRTY/DISABLE_UNTRACKED_FILES_DIRTY/g' ~/.zshrc
sed -i 's/^# HIST_STAMPS/HIST_STAMPS/g' ~/.zshrc
sed -i '54s/^/export _Z_NO_RESOLVE_SYMLINKS="1"\n/' ~/.zshrc
sed -i 's/plugins=(git/plugins=(git svn tmux zsh-syntax-highlighting history-substring-search z/g' ~/.zshrc
echo "[ -f ~/develconfig/fzf.devel ] && source ~/develconfig/fzf.devel" >> ~/.fzf.zsh
echo "run on cmd[source $HOME/.zshrc]"
