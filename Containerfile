FROM docker.io/kalilinux/kali-rolling

# update
RUN set -eux; \
	apt update; \
	apt upgrade -y; \
	rm -rf /var/lib/apt/lists/*;

# root shell
RUN usermod -s /usr/bin/zsh root;

#systemd
RUN set -eux; \
	apt update; \
	apt install -y kali-system-cli; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; \
	\
	mkdir -p /etc/systemd/system/polkit.service.d; \
	echo '[Service]\nMemoryDenyWriteExecute=no\nPrivateDevices=no\nLockPersonality=no\nProtectKernelModules=no\nProtectKernelLogs=no\nProtectKernelTunables=no\nProtectClock=no\nProtectHostname=no\nRestrictAddressFamilies=\nRestrictNamespaces=no\nRestrictRealtime=no\nRestrictSUIDSGID=no\nSystemCallArchitectures=\nSystemCallFilter=' | tee /etc/systemd/system/polkit.service.d/local.conf; \
	\
	echo '#!/usr/bin/bash' | tee /usr/local/sbin/init; \
	echo 'if [ -d /usr/local/etc/init ]' | tee -a /usr/local/sbin/init; \
	echo 'then' | tee -a /usr/local/sbin/init; \
	echo '	for file in /usr/local/etc/init/*.sh' | tee -a /usr/local/sbin/init; \
	echo '	do' | tee -a /usr/local/sbin/init; \
	echo '		bash "$file"' | tee -a /usr/local/sbin/init; \
	echo '	done' | tee -a /usr/local/sbin/init; \
	echo 'fi' | tee -a /usr/local/sbin/init; \
	echo 'exec /usr/sbin/init' | tee -a /usr/local/sbin/init; \
	chmod +x /usr/local/sbin/init;

CMD ["/usr/local/sbin/init"]

# user config
RUN set -eux; \
	sed -i -e 's@60000@2000@g'  -e 's@600100000@60000@g' -e 's@100000@20000@g' -e 's@65536@20000@g' /etc/login.defs; \
	\
	mkdir -p /etc/systemd/system/user-.slice.d; \
	echo '[Slice]' | tee /etc/systemd/system/user-.slice.d/local.conf; \
	echo 'TasksMax=infinity' | tee -a /etc/systemd/system/user-.slice.d/local.conf; \
	\
	mkdir -p /var/lib/systemd/linger;

# git config
RUN set -eux; \
	echo '[init]' | tee /etc/gitconfig; \
	echo 'defaultBranch = main' | tee -a /etc/gitconfig; \
	echo '[commit]' | tee -a /etc/gitconfig; \
	echo 'gpgSign = true' | tee -a /etc/gitconfig; \
	echo '[gpg]' | tee -a /etc/gitconfig; \
	echo 'format = ssh' | tee -a /etc/gitconfig; \
	echo '[gpg.ssh]' | tee -a /etc/gitconfig; \
	echo 'defaultKeyCommand = ssh-add -L' | tee -a /etc/gitconfig;

# desktop
RUN set -eux; \
	apt update; \
	apt install -y kali-desktop-i3; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; \
	\
	mkdir -p /etc/xdg/i3; \
	\
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/config; \
	echo 'include ./*.config' | tee -a /etc/xdg/i3/config; \
	\
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/power.config; \
	echo 'bindsym Mod4+Shift+e exec "i3-nagbar -t warning -m %You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.% -B %Yes, exit i3% %i3-msg exit%"' | sed -e "s@%@'@g" | tee -a /etc/xdg/i3/power.config; \
	echo 'bindsym Mod4+Shift+r restart' | tee -a /etc/xdg/i3/power.config; \
	echo 'bindsym Mod4+Shift+c reload' | tee -a /etc/xdg/i3/power.config; \
	echo 'bindsym Mod4+Shift+l exec i3lock' | tee -a /etc/xdg/i3/power.config; \
	\
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/font.config; \
	echo 'font pango:monospace 8' | tee -a /etc/xdg/i3/font.config; \
	echo '# font pango:DejaVu Sans Mono 8' | tee -a /etc/xdg/i3/font.config; \
	\
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/window.config; \
	echo 'default_border pixel' | tee -a /etc/xdg/i3/window.config; \
	echo 'floating_modifier Mod4' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+Control+q kill' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+h move left' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+j move down' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+k move up' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+l move right' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+Control+h resize shrink width 1 px or 1 ppt' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+Control+j resize grow height 1 px or 1 ppt' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+Control+k resize shrink height 1 px or 1 ppt' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+Control+l resize grow width 1 px or 1 ppt' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+s floating toggle' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+f fullscreen toggle' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+e layout toggle split' | tee -a /etc/xdg/i3/window.config; \
	\
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/workspace.config; \
	echo 'workspace_auto_back_and_forth yes' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+minus workspace prev' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+equal workspace next' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+0 scratchpad show' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+minus exec "i3-msg move container workspace $(node -pe %JSON.parse(process.argv[1]).filter(w => w.focused)[0].num-1% $(i3-msg -t get_workspaces))"' | sed -e "s@%@'@g" | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+equal exec "i3-msg move container workspace $(node -pe %JSON.parse(process.argv[1]).filter(w => w.focused)[0].num+1% $(i3-msg -t get_workspaces))"' | sed -e "s@%@'@g" | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+0 move scratchpad' | tee -a /etc/xdg/i3/workspace.config;

RUN set -eux; \
	sed -i -e 's@Flat-Remix-Blue-Dark@Flat-Remix-Blue-Light@' -e 's@Kali-Dark@Kali-Light@' /etc/xdg/gtk-3.0/settings.ini /etc/xdg/qt5ct/qt5ct.conf /etc/xdg/qt6ct/qt6ct.conf;

RUN set -eux; \
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/dex.config; \
	echo 'exec --no-startup-id dex --autostart --environment i3' | tee -a /etc/xdg/i3/dex.config;

RUN set -eux; \
	mkdir -p /usr/share/backgrounds/pure; \
	convert -size 1x1 xc:black /usr/share/backgrounds/pure/black.png; \
	\
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/wallpaper.config; \
	echo 'exec_always --no-startup-id feh --no-fehbg --bg-scale /usr/share/backgrounds/pure/black.png' | tee -a /etc/xdg/i3/wallpaper.config;

RUN set -eux; \
	mkdir -p /etc/xdg/polybar; \
	echo 'include-file = /etc/polybar/config.ini'  | tee /etc/xdg/polybar/config.ini; \
	echo '[bar/default]'  | tee -a /etc/xdg/polybar/config.ini; \
	echo 'inherit = bar/example'  | tee -a /etc/xdg/polybar/config.ini; \
	echo 'modules-left = xworkspaces'  | tee -a /etc/xdg/polybar/config.ini; \
	echo 'modules-center = xwindow'  | tee -a /etc/xdg/polybar/config.ini; \
	echo 'modules-right = systray'  | tee -a /etc/xdg/polybar/config.ini; \
	echo '#!/usr/bin/bash'  | tee /etc/xdg/polybar/launch.sh; \
	echo 'polybar-msg cmd quit'  | tee -a /etc/xdg/polybar/launch.sh; \
	echo 'polybar default & disown'  | tee -a /etc/xdg/polybar/launch.sh; \
	chmod +x /etc/xdg/polybar/launch.sh; \
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/bar.config; \
	echo 'exec_always --no-startup-id /etc/xdg/polybar/launch.sh' | tee -a /etc/xdg/i3/bar.config;

RUN set -eux; \
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/dmenu.config; \
	echo 'bindsym Mod4+Return exec "rofi -show-icons -modi drun,run -show drun"' | tee -a /etc/xdg/i3/dmenu.config;

RUN set -eux; \
	apt update; \
	apt install -y qterminal; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; \
	\
	sed -i -e 's@colorScheme=Kali-Dark@colorScheme=Kali-Light\nKeyboardCursorShape=2@' /etc/xdg/qterminal.org/qterminal.ini; \
	\
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/terminal.config; \
	echo 'bindsym Mod4+backslash exec qterminal' | tee -a /etc/xdg/i3/terminal.config;

RUN set -eux; \
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/print.config; \
	echo 'bindsym Print exec flameshot gui' | tee -a /etc/xdg/i3/print.config;

RUN set -eux; \
	mkdir -p /etc/skel/.mozilla/firefox; \
	echo '[General]' | tee /etc/skel/.mozilla/firefox/profiles.ini; \
	echo 'StartWithLastProfile=1' | tee -a /etc/skel/.mozilla/firefox/profiles.ini; \
	echo 'Version=2' | tee -a /etc/skel/.mozilla/firefox/profiles.ini; \
	echo '[Profile0]' | tee -a /etc/skel/.mozilla/firefox/profiles.ini; \
	echo 'Name=default' | tee -a /etc/skel/.mozilla/firefox/profiles.ini; \
	echo 'IsRelative=1' | tee -a /etc/skel/.mozilla/firefox/profiles.ini; \
	echo 'Path=../../.config/firefox' | tee -a /etc/skel/.mozilla/firefox/profiles.ini; \
	echo 'Default=1' | tee -a /etc/skel/.mozilla/firefox/profiles.ini; \
	mkdir -p /etc/skel/.config/firefox;

# remote desktop
RUN set -eux; \
	apt update; \
	apt install -y tigervnc-standalone-server; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; \
	\
	echo '[VNCServer]' | tee /etc/lightdm/lightdm.conf.d/vnc.conf;  \
	echo 'enabled = true' | tee -a /etc/lightdm/lightdm.conf.d/vnc.conf;  \
	echo 'command = Xvnc -SecurityTypes None' | tee -a /etc/lightdm/lightdm.conf.d/vnc.conf;  \
	echo 'depth = 32' | tee  -a /etc/lightdm/lightdm.conf.d/vnc.conf;

EXPOSE 5900

# Chinese
RUN set -eux; \
	apt update; \
	apt install -y locales; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; \
	\
	ln -sf ../usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
	\
	sed -i -e 's@# zh_CN.UTF-8@zh_CN.UTF-8@' /etc/locale.gen; \
	locale-gen; \
	echo 'LANG=zh_CN.UTF-8' | tee /etc/locale.conf;

RUN set -eux; \
	apt update; \
	apt install -y fcitx5-pinyin-gui; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;

# tools
RUN set -eux; \
	apt update; \
	apt install -y xarchiver; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;

RUN set -eux; \
	apt update; \
	apt install -y code-oss; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;

RUN set -eux; \
	apt update; \
	apt install -y podman; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;  \
	\
	chmod u=rwx,go=rx /usr/bin/newuidmap /usr/bin/newgidmap; \
	setcap cap_setuid=ep /usr/bin/newuidmap; \
	setcap cap_setgid=ep /usr/bin/newgidmap; \
	\
	echo '[containers]' | tee /etc/containers/containers.conf; \
	echo 'netns = "host"' | tee -a /etc/containers/containers.conf; \
	echo 'ipcns = "host"' | tee -a /etc/containers/containers.conf; \
	echo 'utsns = "host"' | tee -a /etc/containers/containers.conf; \
	echo 'ncgroupns = "host"' | tee -a /etc/containers/containers.conf; \
	echo 'cgroups = "disabled"' | tee -a /etc/containers/containers.conf; \
	\
	mkdir -p /etc/skel/.config/containers; \
	echo '[containers]'  | tee /etc/skel/.config/containers/containers.conf; \
	echo 'volumes = ["/proc:/proc"]' | tee -a /etc/skel/.config/containers/containers.conf;

RUN set -eux; \
	apt update; \
	apt install -y wireshark; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;

RUN set -eux; \
	apt update; \
	apt install -y \
		libreoffice \
		libreoffice-l10n-zh-cn \
		; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;

RUN set -eux; \
	apt update; \
	apt install -y cargo; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;

RUN set -eux; \
	apt update; \
	apt install -y golang; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;

RUN set -eux; \
	apt update; \
	apt install -y \
		python-is-python3 \
		python3-requests \
		python3-flask \
		; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;

# 企业微信
RUN set -eux; \
	wget -O- https://deepin-wine.i-m.dev/setup.sh | sh; \
	apt update; \
	apt install -y libsane1=1.2.1-5deepin1+rb1 libsane-common=1.2.1-5deepin1+rb1 com.qq.weixin.work.deepin; \
	apt autoremove -y; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;  \
	\
	sed -i -e 's@7z x "$APPDIR/$APPTAR" -o"$1"@7z x "$APPDIR/$APPTAR" -o"$1" || true@g' /opt/deepinwine/tools/run.sh /opt/deepinwine/tools/run_v2.sh /opt/deepinwine/tools/run_v3.sh /opt/deepinwine/tools/run_v4.sh; \
	sed -i -e 's@Icon=com.qq.weixin.work.deepin@Icon=/opt/apps/com.qq.weixin.work.deepin/entries/icons/hicolor/48x48/apps/com.qq.weixin.work.deepin.svg@' /opt/apps/com.qq.weixin.work.deepin/entries/applications/com.qq.weixin.work.deepin.desktop; \
	ln -sf /opt/apps/com.qq.weixin.work.deepin/entries/applications/com.qq.weixin.work.deepin.desktop /usr/share/applications/; \
	\
	echo 'assign [class=com.qq.weixin.work.deepin] workspace Chat' | tee /etc/xdg/i3/chat.config;

# user
RUN set -eux; \
	useradd -m -s /usr/bin/zsh -G kali-trusted bonjour; \
	touch /var/lib/systemd/linger/bonjour; \
	echo 'bonjour' | passwd -s bonjour;