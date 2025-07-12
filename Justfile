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
    mkdir -p ~/.local/bin
    echo '''
    #!/bin/bash''' > ~/.local/bin/update-bluefin-wallpaper.sh
    chmod +x ~/.local/bin/update-bluefin-wallpaper.sh