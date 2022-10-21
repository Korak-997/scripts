#!/bin/bash
error="\e[1m\e[31m"
info="\e[1m\e[34m"
process="\e[32m"


if [ "$#" -ne 2 ]; then
    echo -e "$error Illegal number of parameters"
    echo -e "$error param 1:  name for git user"
    echo -e "$error param 2:  email for git"
    exit
fi


echo -e "$info 👊____STARTING SETUP____👊"
echo -e "$info This list will be installed, configured 👇"
echo -e "$info 1- Git + basic configs"
echo -e "$info 2- NVM (Node Version Manager)"
echo -e "$info 3- RVM (Ruby Version Manager)"
echo -e "$info 4- git-radar"
echo -e "$info 5- Node lts"
echo -e "$info _______________________________"
echo  " "
echo -e "$info I got ($1) as git username and ($2) as git email"
echo -e "$info _______________________________"


restart(){
    echo -e "$info restarting..."
    sudo reboot
}

update_packages(){
    echo -e "$process Updating and Upgrading..."
    cd ~
    sudo apt update && sudo apt upgrade -y
    wait
}


install_and_configure_git(){
    if ! command -v git &> /dev/null
    then
        update_packages
        echo -e "$process installing git..."
        sudo apt install git-all
        wait
        echo -e "$process consfiguring git..."
        git config --global user.name "$1"
        git config --global user.email "$2"
        git config --global core.editor nano
        echo -e "$process git installed and configured"
        generate_ssh
        wait
    else
        echo -e "$info Git is already installed no job for me 😞"
    fi
}

generate_ssh(){
    update_packages
    echo -e "$process generating SSH key..."
    mkdir "sshKey"
    ssh-keygen -t ed25519 -C "$2" -f "./sshKey"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    echo -e "$process SSH key generated you can add it in Github"
}

install_nvm(){
    if ! command -v nvm &> /dev/null
    then
        update_packages
        echo -e "$process installing (NVM)..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
        wait
        export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    else
        echo -e "$info NVM is already installed no job for me 😞"
    fi
}


install_nodejs(){
    if ! command -v node &> /dev/null
    then
        update_packages
        nvm install --lts
        wait
    else
        echo -e "$info NVM is already installed no job for me 😞"
    fi
}

install_rvm(){
    if ! command -v rvm &> /dev/null
    then
        update_packages
        echo -e "$process installing (RVM)..."
        sudo apt-get install software-properties-common
        wait
        sudo apt-add-repository -y ppa:rael-gc/rvm
        sudo apt-get update
        wait
        sudo apt-get install rvm
        wait
        sudo usermod -a -G rvm $USER
        echo 'source "/etc/profile.d/rvm.sh"' >> ~/.bashrc
        wait

    else
        echo -e "$info RVM is already installed no job for me 😞"
    fi
}

install_ruby(){
    if ! command -v rvm &> /dev/null
    then
        update_packages
        echo -e "$process installing (Ruby)..."
        rvm install ruby
        wait
        gem install rails
        wait

    else
        echo -e "$info Ruby is already installed no job for me 😞"
    fi
}

install_git_radar(){
    update_packages
    if ! command -v git-radar &> /dev/null
    then
        update_packages
        echo -e "$process installing (Git-radar)\e[5m..."
        cd ~ && git clone https://github.com/michaeldfallen/git-radar .git-radar
        wait
        echo 'export PATH=$PATH:$HOME/.git-radar' >> ~/.bashrc
        echo 'export PS1="$PS1\$(git-radar --bash --fetch)"'
        echo 'export GIT_RADAR_FORMAT=%{local}--%{changes}--%{remote}--[%{branch}]'

    else
        echo -e "$info git-radar is already installed no job for me 😞"
    fi
}
