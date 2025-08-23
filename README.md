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

While it can be launched from the terminal with `kitty`, it can be more
intimately integrated with the system. Let's create a desktop entry for it.

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

#### [neovim](https://neovim.io/) — text/code editor  

You open up the start screen by running the alias `n` in the terminal, or directly editing a file with adding that after the prompt.

The filestructure of the config is modular, meaning that plugins are put as lua files in a plugins dir, /default or /extra depending on when it needs to be active. You can navigate to the config directory by running `cfv` in the terminal.

You will likely want to install an lsp-plugin if you will write code in neovim.

Run this to take the `vimtutor`.

```bash
sudo apt install vim
vimtutor
```

Psst, you exit using `:q!`, `ZZ` (or in my modified version of neovim) using `ALT + q`.

Perhaps the vimmode for VSCode will be easier for a new user when working on projects, but not for system files.

Should you work with code solely using neovim and the terminal, you will need a multiplexer, especially if you´re not on a tiling WM. I am not doing heavy coding and spent most time writing text and auxiliary functions in Emacs, but I prefer using neovim for other things and there is where [tmux](https://github.com/tmux/tmux/wiki) is a must-have. I have yet to use it much, but can feel the need when struggling with documents.

I was going to recommend [helix](https://helix-editor.com/) as it comes prebuilt with most of the plugins someone will end up using for neovim, however, the version provided by `apt` didn´t have a working syntax highlighting, so it had to be built from source. Also, I lack experience with it. Although it might still be worth a consideration. See the [documentation](https://docs.helix-editor.com/) for more.

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

Most use cases for specific software one lingers to comes down to *familiarity*, **not** *function*. The average Office user will quickly adapt to LibreOffice or OnlyOffice, for their Word and Excel alternatives. For the advanced user that needs to write in a specific format with specific extensions, might use LaTeX and R (ggplot etc.) instead. But there are so many more options to solve the same problem, and it is a fallacy to think that the GUI of a text editor or IDE is what makes the text or the code. So long as you stick to only using what you are comfortable with, you will never see the complete picture.

The general advice is to dive straight in to overcome that initial burden. But  there are of course some specific software like Adobe Photoshop, CAD software, and other niche things that you can´t natively run on Linux. Ordinarily you would use a dual boot for this, a separate Windows machine or (God forbid) Wine to run it, as of writing this I was made aware of an approach that using VMs. For more information about this, see [this video](https://www.youtube.com/watch?v=mdnbIXArwVk).

### 5. (KDE) Enable Flatpaks
The instructions are [here](https://userbase.kde.org/Tutorials/Flatpak).

Offers easy downloads for software like Zotero, RStudio, Spotify etc.

---

## Look and Feel

The install set gruvbox as default themes for `kitty` and `neovim`, but you can change them if you want.

If you'd like to stick to using gruvbox, look for wallpapers [here](https://gruvbox-wallpapers.pages.dev/).

### Kitty

- Download themes from [kitty-themes](https://github.com/dexpota/kitty-themes)  
- Apply your preferred theme.

### neovim

Find a theme on [github](https://github.com/topics/neovim-theme), download the luafile into 


Enable it by opening neovim and running `SPACE > `

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
