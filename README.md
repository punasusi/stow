# My public dotfiles
This is not all my dotfiles, but the ones related to the shell prompt setup I use.

## Requrements
- git
- GNU stow

## Dependancies
These are the dependancies I have installed via homebrew, you may not need them all, but including for reference:

bat
fzf
gh
helm
int128/kubelogin/kubelogin
just
k9s
kind
kubecolor
kubernetes-cli
kustomize
oh-my-posh
pre-commit
ripgrep
stow
zellij
zoxide

## Installation

Checkout the repo in your $HOME folder using git.
```bash
git clone git@github.com:punasusi/stow.git 
cd stow
```

Then use GNU stow to create the symlinks 

```bash
stow .
```

If the files already exist, you can direct stow to adopt them.

```bash
stow . --adopt
```

## Kubectl use
I also have created a symlink for ~/.kube/config to point to /dev/null.

This ensures that by default, I'm not contaminating a core kube config file when running various commands for tools which try to update the kubeconfig.

I explicitly export every kubeconfig context to it's own yaml file. Then I use the alias/function ek in .zshrc to search ~/.kube/ , the current directory and parent directories for yaml files which are kube config files. These are displayed and I can select which one to export. 
The alias uek un-exports the kubeconfig, so it's pointing again to /dev/null. 
Also, in my prompt setup, if there is a kubeconfig variable set, it will be displayed and visible in the propmt.