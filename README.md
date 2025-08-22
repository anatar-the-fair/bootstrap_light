# Bootstrap Light — Debian Setup

This repository contains a minimal setup to configure a fresh Debian install with my preferred tools, shell, and editor environment.

---

## Basics

Update your system, install `git`, `wget`, and `stow`, then clone this repo and run the installer:

Open up a terminal with `CTRL + ALT + T` then copy and paste (`CTRL + SHIFT + V`) the following.

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git wget stow

git clone https://github.com/anatar-the-fair/bootstrap_light.git ~/dotfiles
cd ~/dotfiles

chmod +x install.sh
./install.sh
```

---

## Terminal Tweaks

### (KDE) Set Kitty as your default terminal

While it can be launched from the terminal with `kitty`, it is less integrated with the system this way. So let's create a desktop entry for it.

```bash
mkdir -p ~/.local/share/applications
hx ~/.local/share/applications/kitty.desktop
```

Paste the following:
```bash
[Desktop Entry]
Name=Kitty
Comment=Kitty Terminal Emulator
Exec=kitty
Icon=kitty
Type=Application
Categories=System;TerminalEmulator;
StartupNotify=true
Terminal=false
```

Save and exit with `:wq!`

Update KDE's database:

```bash
update-desktop-database ~/.local/share/applications
```

There are many ways to get kitty to launch with `CTRL + ALT + T`.  One way is by directly binding the desktop application we created. Open **System Settings** > **Shortcuts**, disable **Konsole** by unchecking its keybind, then clicking apply. Click "Add New", search for "Kitty", click "+ Add...", press `CTRL + ALT + T`, click "Apply".

See [this](https://sw.kovidgoyal.net/kitty/overview/#) for instructions on how to use kitty.

### (KDE) Adjust keyboard repeat delay and rate:

I set my delay to 200 (ms) and my rate to 50, but you will likely want them slower (250; 100).

Open a terminal and type:

```bash
kcmshell6 kcm_keyboard 
```

Or use `ALT + SPACE` to open KRunner (more of that later), then search for "Keyboard". The settings can also be configured by opening `.config/kdeglobals` and searching (`/`) for "Keyboard".

---

## Additional Steps

### 1. Learn Key Tools

#### [zoxide](https://www.youtube.com/watch?v=aghxkpyRVDY) — smarter directory navigation
I have already made `cd` an alias for "`z`/`zoxide`" in the aliases. You can change it in your `.zshrc` (`cfz` in terminal).

#### [fzf](https://www.youtube.com/watch?v=MvLQor1Ck3M) — fuzzy file finder and history search
It is bound to `CTRL + R` (see the `.config/zsh/.zshrc` (aliased to `cfz`)).

#### [helix](https://helix-editor.com/) — code editor  
See the [documentation](https://docs.helix-editor.com/) for
more.

Works like neovim, but comes preconfigured with most plugins people end up using. For a newer user, it is far superior. Just like with `vim`, you exit using `:q`.

That said, you should still take the `vimtutor`.
```bash
sudo apt install vim
vimtutor
```
You can extend helix
using [marksman](https://github.com/artempyanykh/marksman), which, depending on your use case, could make things like Obsidian redundant.

#### yazi — terminal file manager
Let's install yazi and its dependencies.
```bash
sudo apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick
```

Download the latest release from [yazi's official repo](https://github.com/sxyazi/yazi/releases). As of now, it is:
```bash
wget -O https://github.com/sxyazi/yazi/releases/download/v25.5.31/yazi-x86_64-unknown-linux-gnu.zip ~/.local/bin
unzip ~/.local/bin/yazi-x86_64-unknown-linux-gnu.zip yazi
rm ~/.local/bin/yazi-x86_64-unknown-linux-gnu.zip
```

Since the profile sources .local/bin and its subdirs, we can now use `yazi` or the alias `y` (see `.config/zsh/.zshrc`).

Moreover, I have bound `y` to `yazicd` so that when you exit using `q`, it drops you in the terminal in that directory.

#### (KDE) KRunner
Launch KRunner with `ALT + SPACE`

### 2. Browsers
- Export bookmarks from your current browser.  
- Consider migrating to Firefox or LibreWolf.  
- Get a password manager setup with browser integration (e.g., KeePassXC).
- Install browser extensions like ublockorigin, privacybadger, youtubesponsorblock

### 3. Configure Git

- Set up a global Git user:

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

- Configure SSH keys for GitHub or other services.

### 4. What About Office
If helix does not
initially suffice for
editing documents,
consider Obsidian for
markdown, and use Google Docs
or online MicrosoftWord
until you are ready to
make the change.

New users beware! The
mindset of wanting to
have the windows
experience on Linux is a
fallacy; once you
understand *what you need
a program for*, e.g. edit
text, edit code, you will
see that what the GUI
software does can be
accomplished in new ways.
However, if you use the
software you know because
you are comfortable with
it, you will likely never
see this.

### 5. (KDE) Enable Flatpaks
The instructions are [here](https://userbase.kde.org/Tutorials/Flatpak).

Offers easy downloads for software like Zotero, RStudio, Spotify etc.

---

## Look and Feel

The install set gruvbox as default themes for `kitty` and `helix`, but you can change them if you want.

If you'd like to stick to using gruvbox, look for wallpapers [here](https://gruvbox-wallpapers.pages.dev/).

### Kitty

- Download themes from [kitty-themes](https://github.com/dexpota/kitty-themes)  
- Apply your preferred theme.

### Helix

To set helix as your editor of choice, we must first download it (building it from source to get its syntax highlighting working). Run:

```bash

```


Type `cfh` to edit the helix config and select a theme from [Helix Themes](https://helix-editor.vercel.app/reference/list-of-themes)

### Ricing

#### Fonts

I recommend [Iosevka](https://github.com/be5invis/Iosevka/releases) for monospace and [Libertinus](https://github.com/alerque/libertinus/releases) generally.

I have the fonts part of this github repo, all you need to do to use them is run the following (also installs two other basic icon fonts):

```bash
# Install basic icons
sudo apt install fonts-noto-color-emoji fonts-font-awesome

# Symlink the prebuilt fontconfig and fonts

cd ~/dotfiles
stow --target=$HOME fonts

fc-cache -f -v
```

#### Icons, Themes and More

Open System Settings, go to "Colors & Themes", configure to your liking.

Transparency can be added in **System Settings** > **Workspace Behavior** > **Desktop Effects**
