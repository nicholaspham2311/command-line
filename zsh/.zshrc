# Set up the prompt
autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.config/zsh/.zsh_history

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -v


# # Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Use modern completion system
autoload -Uz compinit
compinit

# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# loading nvm zsh sow down | fix it
nvm() {
  echo "🚨 NVM not loaded! Loading now..."
  unset -f nvm
  export NVM_PREFIX=$(brew --prefix nvm)
  [ -s "$NVM_PREFIX/nvm.sh" ] && . "$NVM_PREFIX/nvm.sh"
  nvm "$@"
}

# aliasrc file = alias + function + stuff | sorry I'm nood
# source ~/.config/zsh/aliasrc.zsh  2>/dev/null

u () {
    if [ -f $1 ]; then
        case $1 in
            *.tar.bz2)  tar -jxvf $1                        ;;
            *.tar.gz)   tar -zxvf $1                        ;;
            *.bz2)      bunzip2 $1                          ;;
            *.dmg)      hdiutil mount $1                    ;;
            *.gz)       gunzip $1                           ;;
            *.tar)      tar -xvf $1                         ;;
            *.tbz2)     tar -jxvf $1                        ;;
            *.tgz)      tar -zxvf $1                        ;;
            *.zip)      unzip $1                            ;;
            *.ZIP)      unzip $1                            ;;
            *.pax)      cat $1 | pax -r                     ;;
            *.pax.Z)    uncompress $1 --stdout | pax -r     ;;
            *.rar)      unrar x $1                          ;;
            *.Z)        uncompress $1                       ;;
            *)          echo "'$1' cannot be extracted/mounted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

tv () {
    pactl set-card-profile 0 output:hdmi-stereo
    xrandr --output LVDS-1 --off --output VGA-1 --off --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DP-1 --off --output HDMI-2 --off --output HDMI-3 --off --output DP-2 --off --output DP-3 --off
}

24-bit-color () {
    bash ~/.config/zsh/function/24-bit-color.sh
}

print256colours () {
    bash ~/.config/zsh/functions/print256colours.sh
}

showTrueColor () {
    bash ~/.config/zsh/functions/showTrueColor.sh
}

dl () {
	cd ~/Downloads
	aria2c $argv
	ls -lah ~/Downloads
	cd -
}

run () {
	if ls $argv | grep ".cpp"
    then
        g++ $argv
		./a.out
		rm a.out
	elif ls $argv | grep ".c"
    then
		gcc $argv
		./a.out
        rm a.out
    fi
}

cpppro () {
    mkdir $argv
    cd $argv
    cp -r ~/.config/nvim/stuff/cpppro/* .
    nvim -O *
}

runcpp () {
    g++ *.cpp
    ./a.out
    rm a.out
}

r () {
	while true
    do
		$argv
		sleep 1
    done
}

SERVER_IP () {
	hostname -I
}

se () {
	browser-sync start --server --files . --no-notify --host SERVER_IP --port 9000
}

########################################################################

set -U EDITOR nvim
export EDITOR='nvim'
export VISUAL='nvim'

# lazy code
# alias l='ls -lha'
# ls, tree more color
alias l='clear ; exa -al --color=always --group-directories-first'
alias ls='clear ; exa -al --color=always --group-directories-first'
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'

# alias fd='fdfind'
alias cpf='xclip -sel clip'
alias re='source ~/.config/zsh/.zshrc'
alias tmuxr='tmux source ~/.tmux.conf'
alias g='grep'
alias h='htop'
alias e='exit'
alias :q='exit'
alias p='ipython3'
alias rbn='sudo reboot now'
alias sdn='sudo shutdown now'
alias mkd='mkdir -pv'
alias ka='killall'
alias v='nvim'
alias o='open'
alias 777='chmod -R 777'
alias x='chmod +x'
alias f='fdfind . -H | grep'
alias c='clear'

# ubuntu apt
alias ins='sudo apt install -y'
alias uins='sudo apt remove -y'

# fedora dnf
# alias ins='sudo dnf install -y'
# alias uins='sudo dnf remove -y'

# arch
# alias ins='sudo pacman -S --noconfirm'
# alias uins='sudo pacman -Rs --noconfirm'

# tmux
# alias ide='tmux split-window -v -p 30 ; tmux split-window -h -p 66 ; tmux split-window -h -p 50'
alias ide='tmux split-window -v -p 20 ; tmux split-window -h -p 75'
alias qa='tmux ls; tmux kill-session -a'

# cd
alias ..='cd .. ; clear ; l'
alias ...='cd .. ; cd .. ; cd .. ; clear ; l'
alias dow='cd ~/Downloads ; clear ; l'
alias doc='cd ~/Documents ; clear ; l'

# youtube-dl
alias yt='youtube-dl --add-metadata -i'
alias yta='yt -x --audio-format mp3'

# trash-cli
alias t='trash'
alias tdl='trash ~/Downloads/*'

# fzf
alias cf='cd ~/.config/ ; nvim -o $(fzf)'
# export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_COMMAND='fdfind -H --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# paper color
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:#4d4d4c,bg:#eeeeee,hl:#d7005f
    --color=fg+:#4d4d4c,bg+:#e8e8e8,hl+:#d7005f
    --color=info:#4271ae,prompt:#8959a8,pointer:#d7005f
    --color=marker:#4271ae,spinner:#4271ae,header:#4271ae'

# gruvbox dark
# export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
        # --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
        # --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54'

fco () {
  git branch --all | grep -v HEAD | string trim | fzf | read -l result; and git checkout "$result"
}

flog () {
  git log --pretty=oneline --abbrev-commit --reverse | fzf --tac +s -e | awk '{print $1;}' | read -l result; and git checkout "$result"
}

# git
alias yo='git add -A ; git commit -m "$(curl -s whatthecommit.com/index.txt)"'
alias sta='git status'
alias push="git push"
alias pull="git pull" 
alias clone='git clone'
alias commit='git commit -m'
alias prettier='prettier --write .'
alias okp='prettier ; yo ; push '
alias ok='yo ; push'

ghdotfiles () {
    cp -r ~/.config/vifm/* ~/git/dotfiles/vifm
	cp ~/.selected_editor ~/git/dotfiles
	cp ~/.gitconfig  ~/git/dotfiles/git/
	cp ~/.config/tmux/.tmux.conf ~/git/dotfiles/tmux/
    cp ~/.config/zsh/.zshrc ~/git/dotfiles/zsh/
    cp -r ~/.config/zsh/function ~/git/dotfiles/zsh/

    # nvim
	cp ~/.config/nvim/coc-settings.json ~/git/dotfiles/nvim/
    cp ~/.config/nvim/init.vim ~/git/dotfiles/nvim/
    cp -r ~/.config/nvim/stuff ~/git/dotfiles/nvim/
    cp -r ~/.config/nvim/coc-settings.json ~/git/dotfiles/nvim/
    # I don't want you see my undoir, hack me if you can.
    cp -r ~/.config/nvim/undodir ~/git/ok/

	cp -r ~/.config/fish/* ~/git/dotfiles/fish/
    crontab -l > ~/git/dotfiles/crontab/crontabConfig
    cp ~/.config/fish/functions/crontab* ~/git/dotfiles/crontab/
    dconf dump /org/gnome/desktop/wm/keybindings/ > ~/git/dotfiles/keybindings.dconf
    cp -r ~/.fonts ~/git/dotfiles/
	cd ~/git/dotfiles/
	okp ; cd -
}

alias ghlazyscript='cd ~/git/lazyscript ; okp ; cd -'
alias ghlinux_setup='cd ~/git/linux_setup ; okp ; cd -'
alias ghvimium_dark_theme='cd ~/git/vimium_dark_theme ; okp ; cd -'
alias ghFreeCodeCampProject='cd ~/git/FreeCodeCampProject ; okp ; cd -'
alias ghok='cd ~/git/ok ; okp ; cd -'
alias ghdataLab='cd ~/git/dataLab ; okp ; cd -'
alias ghwindowsSetup='cd ~/git/windowsSetup ; okp ; cd -'
alias ghtermuxSetup='cd ~/git/termuxSetup ; okp ; cd -'
alias ghimg='cd ~/git/img ; okp ; cd -'
alias ghthuanpham2311='cd ~/git/thuanpham2311 ; okp ; cd -'
alias ghtheNewsTimes='cd ~/git/theNewsTimes ; okp ; cd -'
alias ghfour-card-feature-section='cd ~/git/four-card-feature-section ; okp ; cd -'
alias ghcalculatorOnIOS='cd ~/git/calculatorOnIOS ; okp ; cd -'

gha () {
	cowsay "git push lazyscript"
	ghlazyscript

	cowsay "git push dotfiles"
	ghdotfiles

	cowsay "git push linux_setup" 
	ghlinux_setup

	cowsay "git push vimium-dark-theme" 
	ghvimium_dark_theme

	cowsay "git push FreeCodeCampProject" 
	ghFreeCodeCampProject

	cowsay "git push ok" 
	ghok

	cowsay "git push dataLab" 
	ghdataLab

	cowsay "git push windowsSetup" 
    ghwindowsSetup

	cowsay "git push termuxSetup" 
    ghtermuxSetup

	cowsay "git push img" 
    ghimg

	cowsay "git push thuanpham2311" 
    ghthuanpham2311

	cowsay "git push theNewsTimes" 
    ghtheNewsTimes

	cowsay "git push four-card-feature-section" 
    ghfour-card-feature-section

	cowsay "git push calculatorOnIOS" 
    ghcalculatorOnIOS

	cowsay "D O N E"
}

alias gldotfiles='cd ~/git/dotfiles ; pull ; cd -'
alias gllazyscript='cd ~/git/lazyscript ; pull ; cd -'
alias gllinux_setup='cd ~/git/linux_setup ; pull ; cd -'
alias glvimium_dark_theme='cd ~/git/vimium_dark_theme ; pull ; cd -'
alias glFreeCodeCampProject='cd ~/git/FreeCodeCampProject ; pull ; cd -'
alias glok='cd ~/git/ok ; pull ; cd -'
alias gldataLab='cd ~/git/dataLab ; pull ; cd -'
alias glwindowsSetup='cd ~/git/windowsSetup ;  pull ; cd -'
alias gltermuxSetup='cd ~/git/termuxSetup ;  pull ; cd -'
alias glimg='cd ~/git/img ; pull ; cd -'
alias glthuanpham2311='cd ~/git/thuanpham2311 ; pull ; cd -'
alias gltheNewsTimes='cd ~/git/theNewsTimes ; pull ; cd -'
alias glfour-card-feature-section='cd ~/git/four-card-feature-section ; pull ; cd -'
alias glcalculatorOnIOS='cd ~/git/calculatorOnIOS ; pull ; cd -'

gla () {
	cowsay "git pull lazyscript" 
	gllazyscript 

	cowsay "git pull dotfiles" 
	gldotfiles 

	cowsay "git pull linux_setup" 
	gllinux_setup 

	cowsay "git pull vimium-dark-theme" 
	glvimium_dark_theme

	cowsay "git pull FreeCodeCampProject" 
	glFreeCodeCampProject 

	cowsay "git pull ok" 
	glok

	cowsay "git pull dataLab" 
	gldataLab

	cowsay "git pull windowsSetup" 
    glwindowsSetup

	cowsay "git pull termuxSetup" 
    gltermuxSetup

	cowsay "git pull img" 
    glimg

	cowsay "git pull thuanpham2311" 
    glthuanpham2311

	cowsay "git pull theNewsTimes" 
    gltheNewsTimes

	cowsay "git pull four-card-feature-section"
    glfour-card-feature-section

	cowsay "git pull calculatorOnIOS"
    glcalculatorOnIOS

	cowsay "D O N E"
}

# browser
alias browser='brave-browser'
# alias browser='google-chrome'
# alias browser='firefox'
alias github='browser --new-window "https://github.com/thuanpham2311"'

alias browser_youtube_subsriptions='browser "https://www.youtube.com/feed/subscriptions"'
alias browser_fb='browser https://facebook.com'
alias browser_stu='browser "http://stu.edu.vn/"'
alias browser_stu2='browser "http://www.stu.edu.vn/vi/265/khoa-cong-nghe-thong-tin.html"'
alias browser_mail0='browser "https://mail.google.com/mail/u/0/#inbox"'
alias browser_mail1='browser "https://mail.google.com/mail/u/1/#inbox"'
alias browser_mail2='browser "https://mail.google.com/mail/u/2/#inbox"'
alias browser_mail='browser_mail0 ; browser_mail1 ; browser_mail2'
alias browser_linkedin='browser "https://www.linkedin.com/feed/"'

browser_daily () {
    cowsay "GET.SHIT.DONE"
    browser_youtube_subsriptions
	browser_linkedin
    browser_mail0
    browser_mail1
	browser_fb
	browser_stu
}

# mode
alias hi='browser_daily ; rem'
# alias rem='sudo dnf update -y ; sudo dnf autoremove -y ; flatpak update -y'
rem () {
    nvim -c "PlugUpdate | qa"
    sudo apt update
    sudo apt upgrade -y
    sudo apt autoremove -y
    sudo apt autoclean
    tldr --update
    sudo npm install -g npm
    clear
}

# arch
# rem () {
    # sudo pacman -Syyu --noconfirm
    # sudo npm install -g npm
    # nvim -c "PlugUpdate | qa"
    # tldr --update
# }

data () {
	cd ~/git/dataLab/
	tmux split-window -h -p 50
	jupyter lab
}

# fzf
source /usr/share/fzf/key-bindings.zsh 2>/dev/null
source /usr/share/fzf/completion.zsh 2>/dev/null
# Load zsh-syntax-highlighting; should be last.
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
