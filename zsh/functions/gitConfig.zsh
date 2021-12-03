# !/usr/bin/env zsh

alias st='git status -sb'
alias add='git add'
alias push="git push"
alias pull="git pull"
alias dv='git difftool'

isInGitRepo() { git rev-parse HEAD > /dev/null 2>&1 }

function autoCommit () {
    isInGitRepo || return
    git add -A
    git commit -m "[👌Auto commit] $(curl -s whatthecommit.com/index.txt)"
}

function repoSync () {
    git pull
    git push
}

function ok () {
    isInGitRepo || return
    st
    autoCommit
    repoSync
}

function okp () {
    isInGitRepo || return
    prettier --write *
    st
    autoCommit
    repoSync
}

function gc () {
    gitDir="$(basename "$1" .git)"
    gitDirResolved=${2:-$gitDir}
    git clone "$@" && cd "$gitDirResolved";
}

function yo () {
    git diff
    git add .
    cowsay "What is commmit message?"
    read commitMessage
    git commit -m $commitMessage
    git push
}

function ghi() {
  local item
  item=$(gh issue list | fzf | awk '{print $1}')
  gh issue view $item --web
}

function syncNote () {
    cd ~/sync/note
    autoCommit
    repoSync

    cp -r ~/sync/note/publish ~/.local/share/garden/
    cp ~/sync/note/README.md ~/.local/share/garden/
    cd ~/.local/share/garden/
    autoCommit
    repoSync
}

function autoSync {
    repo=(
        /home/master/sync/ok
        /home/master/repos/co_so_du_lieu
        /home/master/repos/dataLab
        /home/master/repos/ky_thuat_lap_trinh
        /home/master/repos/lap_trinh_huong_doi_tuong
        /home/master/repos/nhap_mon_cau_truc_du_lieu
        /home/master/repos/nhap_mon_web_va_ung_dung
        /home/master/repos/thuc-hanh-ky-thuat-lap-trinh
        /home/master/repos/thuc-hanh-lap-trinh-huong-doi-tuong
        /home/master/repos/thuc-hanh-nhap-mon-cau-truc-du-lieu
        /home/master/repos/thuc-hanh-nhap-mon-web-va-ung-dung
        /home/master/repos/thuc_thanh_nhap_mon_lap_trinh
        /home/master/repos/ublock_adblock_list
        /home/master/repos/cong_nghe_phan_mem
    )

    for i in ${repo[*]}
    do
        echo $i
        cd "$i"
        autoCommit
        repoSync
    done
}
