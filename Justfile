install hemi:
    mkdir -p ~/.config/systemd/user
    echo '''
    [Unit]
    Description=Update Bluefin Wallpaper of the Month
    After=graphical-session.target

    [Service]
    Type=oneshot
    ExecStart=%h/.local/bin/update-bluefin-wallpaper.sh
    RemainAfterExit=true

    [Install]
    WantedBy=default.target''' > ~/.config/systemd/user/bluefin-wallpaper.service
    mkdir -p ~/.local/share/wallpapers/Bluefin
    mkdir -p ~/.local/bin
    echo '''
    #!/bin/bash
    set -oux pipefail

    cd ~/.local/share/wallpapers/Bluefin
    curl -Lo {{hemi}}.md5 https://github.com/grandpares/plasma-bluefin-wallpaper/releases/download/latest/{{hemi}}.md5
    md5sum --status -c {{hemi}}.md5 \
    || curl -Lo {{hemi}}.avif https://github.com/grandpares/plasma-bluefin-wallpaper/releases/download/latest/{{hemi}}.avif''' > ~/.local/bin/update-bluefin-wallpaper.sh
    chmod +x ~/.local/bin/update-bluefin-wallpaper.sh
    systemctl --user daemon-reload
    systemctl --user enable bluefin-wallpaper.service
    systemctl --user start bluefin-wallpaper.service
uninstall:
    systemctl --user disable bluefin-wallpaper.service
    rm -rf ~/.local/share/wallpapers/Bluefin
    rm -f ~/.config/systemd/user/bluefin-wallpaper.service
    rm -f ~/.local/bin/update-bluefin-wallpaper.sh
    systemctl --user daemon-reload
