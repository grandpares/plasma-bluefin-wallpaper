install hemi:
    mkdir -p ~/.config/systemd/user
    echo -e "\
    [Unit]\n\
    Description=Update Bluefin Wallpaper of the Month\n\
    After=graphical-session.target network-online.target\n\
    Wants=network-online.target\n\
    \n\
    [Service]\n\
    Type=oneshot\n\
    ExecStart=%h/.local/bin/update-bluefin-wallpaper.sh\n\
    WorkingDirectory=%h/.local/share/wallpapers/Bluefin\n\
    Environment=HOME=%h\n\
    RemainAfterExit=true\n\
    \n\
    [Install]\n\
    WantedBy=default.target\
    " > ~/.config/systemd/user/bluefin-wallpaper.service
    mkdir -p ~/.local/share/wallpapers/Bluefin
    mkdir -p ~/.local/bin
    echo -e "\
    #!/bin/bash\n\
    set -oux pipefail\n\
    \n\
    while ! curl -fs --max-time 2 https://github.com >/dev/null 2>&1; do\n\
        sleep 2\n\
    done\n\
    curl -Lo {{hemi}}.md5 https://github.com/grandpares/plasma-bluefin-wallpaper/releases/latest/download/{{hemi}}.md5\n\
    md5sum --status -c {{hemi}}.md5 || curl -Lo {{hemi}}.avif https://github.com/grandpares/plasma-bluefin-wallpaper/releases/latest/download/{{hemi}}.avif\
    " > ~/.local/bin/update-bluefin-wallpaper.sh
    chmod +x ~/.local/bin/update-bluefin-wallpaper.sh
    systemctl --user daemon-reload
    systemctl --user enable bluefin-wallpaper.service
    systemctl --user start bluefin-wallpaper.service
uninstall:
    systemctl --user stop bluefin-wallpaper.service
    systemctl --user disable bluefin-wallpaper.service
    rm -rf ~/.local/share/wallpapers/Bluefin
    rm -f ~/.config/systemd/user/bluefin-wallpaper.service
    rm -f ~/.local/bin/update-bluefin-wallpaper.sh
    systemctl --user daemon-reload
