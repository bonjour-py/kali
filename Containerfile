FROM docker.io/kalilinux/kali-rolling

# update
RUN set -eux; \
	\
	apt update; \
	apt upgrade -y; \
	rm -rf /var/lib/apt/lists/*; 

# root shell
RUN usermod -s /usr/bin/zsh root; 

# apt source
ONBUILD RUN sed -i -e 's@http.kali.org@mirrors.tuna.tsinghua.edu.cn@g' /etc/apt/sources.list; 
# Chinese
ONBUILD RUN set -eux; \
	\
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

#systemd
ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y kali-system-cli ; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; \
	mkdir /etc/systemd/system/polkit.service.d/; \
	echo '[Service]\nMemoryDenyWriteExecute=no\nPrivateDevices=no\nLockPersonality=no\nProtectKernelModules=no\nProtectKernelLogs=no\nProtectKernelTunables=no\nProtectClock=no\nProtectHostname=no\nRestrictAddressFamilies=\nRestrictNamespaces=no\nRestrictRealtime=no\nRestrictSUIDSGID=no\nSystemCallArchitectures=\nSystemCallFilter=' | tee /etc/systemd/system/polkit.service.d/local.conf; \
	\
	sed -i -e 's@TasksMax=33%@TasksMax=infinity@' /usr/lib/systemd/system/user-.slice.d/10-defaults.conf; \
	\
	sed -i -e 's@60000@2000@g'  -e 's@600100000@60000@g' -e 's@100000@20000@g' -e 's@65536@20000@g' /etc/login.defs; \
	\
	mkdir -p /var/lib/systemd/linger/;
ONBUILD CMD ["/usr/sbin/init"] 

# desktop
ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y kali-desktop-i3; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; \
	\
	mkdir /etc/xdg/i3/; \
	\
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/config; \
	echo 'include ./*.config' | tee -a /etc/xdg/i3/config; \
	\
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/power.config; \
	echo 'bindsym Mod4+Shift+Escape exec "i3-nagbar -t warning -m %You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.% -B %Yes, exit i3% %i3-msg exit%"' | sed -e "s@%@'@g" | tee -a /etc/xdg/i3/power.config; \
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
	echo 'bindsym Mod4+j move left' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+k move down' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+i move up' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+l move right' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+Control+j resize shrink width 1 px or 1 ppt' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+Control+k resize grow height 1 px or 1 ppt' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+Control+i resize shrink height 1 px or 1 ppt' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+Control+l resize grow width 1 px or 1 ppt' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+h split h' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+v split v' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+s floating toggle' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+f fullscreen toggle' | tee -a /etc/xdg/i3/window.config; \
	echo 'bindsym Mod4+e layout toggle split' | tee -a /etc/xdg/i3/window.config; \
	\
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/workspace.config; \
	echo 'workspace_auto_back_and_forth yes' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+minus workspace prev' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+equal workspace next' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+grave scratchpad show' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+1 workspace 1' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+2 workspace 2' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+3 workspace 3' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+4 workspace 4' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+5 workspace 5' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+6 workspace 6' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+7 workspace 7' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+8 workspace 8' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+9 workspace 9' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+0 workspace 10' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+minus move container workspace prev' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+equal move container workspace next' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+grave move scratchpad' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+1 move container workspace 1' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+2 move container workspace 2' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+3 move container workspace 3' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+4 move container workspace 4' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+5 move container workspace 5' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+6 move container workspace 6' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+7 move container workspace 7' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+8 move container workspace 8' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+9 move container workspace 9' | tee -a /etc/xdg/i3/workspace.config; \
	echo 'bindsym Mod4+Control+0 move container workspace 10' | tee -a /etc/xdg/i3/workspace.config;

ONBUILD RUN set -eux; \
	sed -i -e 's@Flat-Remix-Blue-Dark@Flat-Remix-Blue-Light@' -e 's@Kali-Dark@Kali-Light@' /etc/xdg/gtk-3.0/settings.ini /etc/xdg/qt5ct/qt5ct.conf /etc/xdg/qt6ct/qt6ct.conf;

ONBUILD RUN set -eux; \
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/dex.config; \
	echo 'exec --no-startup-id dex --autostart --environment i3' | tee -a /etc/xdg/i3/dex.config;

ONBUILD RUN set -eux; \
	mkdir /usr/share/backgrounds/pure/; \
	convert -size 1x1 xc:black /usr/share/backgrounds/pure/black.png; \
	mkdir /etc/xdg/nitrogen/; \
	echo '[xin_-1]\nfile=/usr/share/backgrounds/pure/black.png\nmode=4\nbgcolor=#000000' | tee /etc/xdg/nitrogen/bg-saved.cfg; \
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/wallpaper.config; \
	echo 'exec_always --no-startup-id nitrogen --restore' | tee -a /etc/xdg/i3/wallpaper.config;

ONBUILD RUN set -eux; \
	mkdir /etc/xdg/polybar/; \
	echo 'include-file = /etc/polybar/config.ini'  | tee /etc/xdg/polybar/config.ini; \
	echo '[bar/default]'  | tee -a /etc/xdg/polybar/config.ini; \
	echo 'inherit = bar/example'  | tee -a /etc/xdg/polybar/config.ini; \
	echo 'modules-left = xworkspaces'  | tee -a /etc/xdg/polybar/config.ini; \
	echo 'modules-center = xwindow'  | tee -a /etc/xdg/polybar/config.ini; \
	echo 'modules-right = systray pulseaudio'  | tee -a /etc/xdg/polybar/config.ini; \
	echo '#!/usr/bin/env bash'  | tee /etc/xdg/polybar/launch.sh; \
	echo 'polybar-msg cmd quit'  | tee -a /etc/xdg/polybar/launch.sh; \
	echo 'polybar default & disown'  | tee -a /etc/xdg/polybar/launch.sh; \
	chmod +x /etc/xdg/polybar/launch.sh; \
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/bar.config; \
	echo 'exec_always --no-startup-id /etc/xdg/polybar/launch.sh' | tee -a /etc/xdg/i3/bar.config;

ONBUILD RUN set -eux; \
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/dmenu.config; \
	echo 'bindsym Mod4+Return exec "rofi -show-icons -modi drun,run -show drun"' | tee -a /etc/xdg/i3/dmenu.config;

ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y qterminal; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; \
	\
	sed -i -e 's@colorScheme=Kali-Dark@colorScheme=Kali-Light\nKeyboardCursorShape=2@' /etc/xdg/qterminal.org/qterminal.ini; \
	\
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/terminal.config; \
	echo 'bindsym Mod4+backslash exec qterminal' | tee -a /etc/xdg/i3/terminal.config;

ONBUILD RUN set -eux; \
	echo '# i3 config file (v4)' | tee /etc/xdg/i3/print.config; \
	echo 'bindsym Print exec flameshot gui' | tee -a /etc/xdg/i3/print.config;

# remote desktop
ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y tigervnc-standalone-server; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; \
	\
	echo '[VNCServer]' | tee /etc/lightdm/lightdm.conf.d/vnc.conf;  \
	echo 'enabled = true' | tee -a /etc/lightdm/lightdm.conf.d/vnc.conf;  \
	echo 'command = Xvnc -SecurityTypes None' | tee -a /etc/lightdm/lightdm.conf.d/vnc.conf;  \
	echo 'depth = 32' | tee  -a /etc/lightdm/lightdm.conf.d/vnc.conf;  
ONBUILD EXPOSE 5900

# desktop base tool 
ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y fcitx5-pinyin-gui; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; 

ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y xarchiver; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;
	
ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y code-oss; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;

#tools
ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y podman; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*;  \
	\
	chmod 0755 /usr/bin/newuidmap /usr/bin/newgidmap; \
	setcap cap_setuid=ep /usr/bin/newuidmap; \
	setcap cap_setgid=ep /usr/bin/newgidmap; \
	\
	echo '[containers]\nnetns = "host"\nuserns = "host"\nipcns = "host"\nutsns = "host"\ncgroupns = "host"\ncgroups = "disabled"' | tee /etc/containers/containers.conf; \
	\
	mkdir /etc/skel/.config/containers/; \
	echo '[containers]\nvolumes = ["/proc:/proc"]' | tee /etc/skel/.config/containers/containers.conf; 

ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y wireshark; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; 
ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y libreoffice libreoffice-l10n-zh-cn; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; 

#lang
ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y cargo; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; 

ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y golang; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; 

ONBUILD RUN set -eux; \
	\
	apt update; \
	apt install -y \
		python-is-python3 \
		python3-requests \
		python3-flask \
		; \
	apt clean; \
	rm -rf /var/lib/apt/lists/*; 

# user
ONBUILD RUN set -eux; \
	\
	useradd -m -s /usr/bin/zsh -G kali-trusted bonjour; \
	touch /var/lib/systemd/linger/bonjour; \
	echo 'bonjour' | passwd -s bonjour; 

ONBUILD COPY --chown=bonjour:bonjour --chmod=700 ./ssh /home/bonjour/.ssh
ONBUILD COPY --chown=bonjour:bonjour ./git /home/bonjour/.config/git
