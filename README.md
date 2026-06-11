<div align="center">
  <a href="https://github.com/m1k1o/neko" title="Neko's Github repository.">
    <img src="https://neko.m1k1o.net/img/logo.png" width="400" height="auto"/>
  </a>
  <p align="center">
    <a href="https://github.com/m1k1o/neko/releases">
      <img src="https://img.shields.io/github/v/release/m1k1o/neko" alt="release">
    </a>
    <a href="https://github.com/m1k1o/neko/blob/master/LICENSE">
      <img src="https://img.shields.io/github/license/m1k1o/neko" alt="license">
    </a>
    <a href="https://hub.docker.com/r/m1k1o/neko">
      <img src="https://img.shields.io/docker/pulls/m1k1o/neko" alt="pulls">
    </a>
    <a href="https://github.com/m1k1o/neko/issues">
      <img src="https://img.shields.io/github/issues/m1k1o/neko" alt="issues">
    </a>
    <a href="https://github.com/sponsors/m1k1o">
      <img src="https://img.shields.io/badge/-sponsor-red" alt="issues">
    </a>
    <a href="https://discord.gg/HXQJmqNJMz">
      <img src="https://discordapp.com/api/guilds/665851821906067466/widget.png" alt="Chat on discord">
    </a>
    <a href="https://hellogithub.com/repository/4536d4546af24196af3f08a023dfa007" target="_blank">
      <img src="https://abroad.hellogithub.com/v1/widgets/recommend.svg?rid=4536d4546af24196af3f08a023dfa007&claim_uid=0x19e4dJwD83aW2&theme=small" alt="Featured｜HelloGitHub" />
    </a>
    <a href="https://github.com/m1k1o/neko/actions">
      <img src="https://github.com/m1k1o/neko/actions/workflows/ghcr.yml/badge.svg" alt="build">
    </a>
  </p>
  <img src="https://neko.m1k1o.net/img/intro.gif" width="650" height="auto"/>
</div>

# n.eko

Welcome to Neko, a self-hosted virtual browser that runs in Docker and uses WebRTC technology. Neko is a powerful tool that allows you to **run a fully-functional browser in a virtual environment**, giving you the ability to **access the internet securely and privately from anywhere**. With Neko, you can browse the web, **run applications**, and perform other tasks just as you would on a regular browser, all within a **secure and isolated environment**. Whether you are a developer looking to test web applications, a **privacy-conscious user seeking a secure browsing experience**, or simply someone who wants to take advantage of the **convenience and flexibility of a virtual browser**, Neko is the perfect solution.

In addition to its security and privacy features, Neko offers the **ability for multiple users to access it simultaneously**. This makes it an ideal solution for teams or organizations that need to share access to a browser, as well as for individuals who want to use **multiple devices to access the same virtual environment**. With Neko, you can **easily and securely share access to a browser with others**, without having to worry about maintaining separate configurations or settings. Whether you need to **collaborate on a project**, access shared resources, or simply want to **share access to a browser with friends or family**, Neko makes it easy to do so.

Neko is also a great tool for **hosting watch parties** and interactive presentations. With its virtual browser capabilities, Neko allows you to host watch parties and presentations that are **accessible from anywhere**, without the need for in-person gatherings. This makes it easy to **stay connected with friends and colleagues**, even when you are unable to meet in person. With Neko, you can easily host a watch party or give an **interactive presentation**, whether it's for leisure or work. Simply invite your guests to join the virtual environment, and you can share the screen and **interact with them in real-time**.

## About

This app uses WebRTC to stream a desktop inside of a docker container, original author made this because [rabb.it](https://en.wikipedia.org/wiki/Rabb.it) went under and his internet could not handle streaming and discord kept crashing when his friend attempted to. He just wanted to watch anime with his friends ლ(ಠ益ಠლ) so he started digging throughout the internet and found a few *kinda* clones, but none of them had the virtual browser, then he found [Turtus](https://github.com/Khauri/Turtus) and he was able to figure out the rest.

Then I found [this](https://github.com/nurdism/neko) project and started to dig into it. I really liked the idea of having collaborative browser browsing together with multiple people, so I created a fork. Initially, I wanted to merge my changes to the upstream repository, but the original author did not have time for this project anymore and it got eventually archived.

## Use-cases and comparison

Neko started as a virtual browser that is streamed using WebRTC to multiple users.
- It is **not only limited to a browser**; it can run anything that runs on linux (e.g. VLC). Browser only happens to be the most popular and widely used use-case.
- In fact, it is not limited to a single program either; you can install a full desktop environment (e.g. XFCE, KDE).
- Speaking of limits, it does not need to run in a container; you could install neko on your host, connect to your X server and control your whole VM.
- Theoretically it is not limited to only X server, anything that can be controlled and scraped periodically for images could be used instead.
  - Like implementing RDP or VNC protocol, where neko would only act as WebRTC relay server. This is currently only future.

Primary use case is connecting with multiple people, leveraging real time synchronization and interactivity:
- **Watch party** - watching video content together with multiple people and reacting to it (chat, emotes) - open source alternative to [giggl.app](https://giggl.app/) or [hyperbeam](https://watch.hyperbeam.com).
- **Interactive presentation** - not only screen sharing, but others can control the screen.
- **Collaborative tool** - brainstorming ideas, cobrowsing, code debugging together.
- **Support/Teaching** - interactively guiding people in controlled environment.
- **Embed anything** - embed virtual browser in your web app - open source alternative to [hyperbeam API](https://hyperbeam.com/).
  - open any third-party website or application, synchronize audio and video flawlessly among multiple participants.
  - request rooms using API with [neko-rooms](https://github.com/m1k1o/neko-rooms).
- [**Neko inside VR Chat**](https://github.com/jameskitt616/vrchat_streaming) - watch remote browser together with friends in VR.

Other use cases that benefit from single-user:
- **Personal workspace** - streaming containerized apps and desktops to end-users - similar to [kasm](https://www.kasmweb.com/).
- **Persistent browser** - own browser with persistent cookies available anywhere - similar to [mightyapp](https://www.mightyapp.com/).
  - no state is left on the host browser after terminating the connection.
  - sensitive data like cookies are not transferred - only video is shared.
- **Throwaway browser** - a better solution for planning secret parties and buying birthday gifts off the internet.
  - use Tor Browser and [VPN](https://github.com/m1k1o/neko-vpn) for additional anonymity.
  - mitigates risk of OS fingerprinting and browser vulnerabilities by running in container.
- **Session broadcasting** - broadcast room content using RTMP (to e.g. twitch or youtube...).
- **Session recording** - broadcast RTMP can be saved to a file using e.g. [nginx-rtmp](https://www.nginx.com/products/nginx/modules/rtmp-media-streaming/)
  - have clean environment when recording tutorials.
  - no need to hide bookmarks or use incognito mode.
- **Jump host** - access your internal applications securely without the need for VPN.
- **Automated browser** - you can install [playwright](https://playwright.dev/) or [puppeteer](https://pptr.dev/) and automate tasks while being able to actively intercept them.

Compared to clientless remote desktop gateway (e.g. [Apache Guacamole](https://guacamole.apache.org/) or [websockify](https://github.com/novnc/websockify) with [noVNC](https://novnc.com/)), installed with remote desktop server along with desired program (e.g. [linuxserver/firefox](https://docs.linuxserver.io/images/docker-firefox)) provides neko additionally:
- **Smooth video** because it uses WebRTC and not images sent over WebSockets.
- **Built in audio** support, what is not part of Apache Guacamole or noVNC.
- **Multi-participant control**, what is not natively supported by Apache Guacamole or noVNC.

### Supported browsers

<div align="center">
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#firefox">
    <img src="https://neko.m1k1o.net/img/icons/firefox.svg" title="ghcr.io/m1k1o/neko/firefox" width="60" height="auto"/>
  </a>
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#tor-browser">
    <img src="https://neko.m1k1o.net/img/icons/tor-browser.svg" title="ghcr.io/m1k1o/neko/tor-browser" width="60" height="auto"/>
  </a>
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#waterfox">
    <img src="https://neko.m1k1o.net/img/icons/waterfox.svg" title="ghcr.io/m1k1o/neko/waterfox" width="60" height="auto"/>
  </a>
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#chromium">
    <img src="https://neko.m1k1o.net/img/icons/chromium.svg" title="ghcr.io/m1k1o/neko/chromium" width="60" height="auto"/>
  </a>
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#google-chrome">
    <img src="https://neko.m1k1o.net/img/icons/google-chrome.svg" title="ghcr.io/m1k1o/neko/google-chrome" width="60" height="auto"/>
  </a>
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#ungoogled-chromium">
    <img src="https://neko.m1k1o.net/img/icons/ungoogled-chromium.svg" title="ghcr.io/m1k1o/neko/google-chrome" width="60" height="auto"/>
  </a>
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#microsoft-edge">
    <img src="https://neko.m1k1o.net/img/icons/microsoft-edge.svg" title="ghcr.io/m1k1o/neko/microsoft-edge" width="60" height="auto"/>
  </a>
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#brave">
    <img src="https://neko.m1k1o.net/img/icons/brave.svg" title="ghcr.io/m1k1o/neko/brave" width="60" height="auto"/>
  </a>
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#vivaldi">
    <img src="https://neko.m1k1o.net/img/icons/vivaldi.svg" title="ghcr.io/m1k1o/neko/vivaldi" width="60" height="auto"/>
  </a>
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#opera">
    <img src="https://neko.m1k1o.net/img/icons/opera.svg" title="ghcr.io/m1k1o/neko/opera" width="60" height="auto"/>
  </a>

  ... see [all available images](https://neko.m1k1o.net/docs/v3/installation/docker-images)
</div>

### Other applications

<div align="center">
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#xfce">
    <img src="https://neko.m1k1o.net/img/icons/xfce.svg" title="ghcr.io/m1k1o/neko/xfce" width="60" height="auto"/>
  </a>
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#kde">
    <img src="https://neko.m1k1o.net/img/icons/kde.svg" title="ghcr.io/m1k1o/neko/kde" width="60" height="auto"/>
  </a>
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#remmina">
    <img src="https://neko.m1k1o.net/img/icons/remmina.svg" title="ghcr.io/m1k1o/neko/remmina" width="60" height="auto"/>
  </a>
  <a href="https://neko.m1k1o.net/docs/v3/installation/docker-images#vlc">
    <img src="https://neko.m1k1o.net/img/icons/vlc.svg" title="ghcr.io/m1k1o/neko/vlc" width="60" height="auto"/>
  </a>

  ... others in <a href="https://github.com/m1k1o/neko-apps">m1k1o/neko-apps</a>
</div>

### Why neko?

I like cats 🐱 (`Neko` is the Japanese word for cat), I'm a weeb/nerd.

***But why the cat butt?*** Because cats are *assholes*, but you love them anyways.

## Multiple rooms

For neko room management software, visit [neko-rooms](https://github.com/m1k1o/neko-rooms).

It also offers [Zero-knowledge installation (with HTTPS)](https://github.com/m1k1o/neko-rooms/?tab=readme-ov-file#zero-knowledge-installation-with-https).

## Documentation

Full documentation is available at [neko.m1k1o.net](https://neko.m1k1o.net/). Key sections include:

- [Migration from V2](https://neko.m1k1o.net/docs/v3/migration-from-v2)
- [Getting Started](https://neko.m1k1o.net/docs/v3/quick-start)
- [Installation](https://neko.m1k1o.net/docs/v3/installation)
- [Examples](https://neko.m1k1o.net/docs/v3/installation/examples)
- [Configuration](https://neko.m1k1o.net/docs/v3/configuration)
- [Frequently Asked Questions](https://neko.m1k1o.net/docs/v3/faq)
- [Troubleshooting](https://neko.m1k1o.net/docs/v3/troubleshooting)

## How to Contribute

Contributions are welcome! Check the [Contributing Guide](https://neko.m1k1o.net/contributing) for details.

## Support

If you find Neko useful, consider supporting the project via [GitHub Sponsors](https://github.com/sponsors/m1k1o).

---

## ARM64 Widevine Support (Chromium)

> This section covers a local patch for running Chromium with Widevine DRM on ARM64 hosts — for example, an Oracle Cloud free-tier Ampere A1 instance running a Netflix watch party.

### What was changed

Google Chrome does not yet publish an official ARM64 Linux binary, and the standard Widevine CDM from Mozilla's manifest is x86_64 only. The following files were added/modified to enable Widevine on ARM64 via the Chromium image:

| File | Change |
|---|---|
| `apps/chromium/widevinecdm.sh` | Added `arm64` branch: downloads a ChromeOS LaCrOS squashfs image and extracts the Widevine CDM |
| `apps/chromium/widevine_fixup.py` | New file (MIT, David Buchanan / Asahi Linux): patches the ChromeOS Widevine binary to load on standard Linux |
| `apps/chromium/Dockerfile` | Added `arm64` build branch that installs `squashfs-tools` + `python3` and runs the updated script |

**Security note:** The patched Widevine library has weakened memory protections (disabled RELRO, RWX mapping) because the ChromeOS binary was compiled for 4KB pages while Oracle Ampere A1 uses 64KB pages. This is acceptable for a private watch party server but worth knowing.

To update the ChromeOS LaCrOS version used for extraction, pass `--build-arg LACROS_VERSION=<version>` or set the `LACROS_VERSION` environment variable before building.

---

## Oracle Cloud ARM64 Setup Guide

This guide covers deploying neko with Widevine-enabled Chromium on an Oracle Cloud free-tier Ampere A1 instance for Netflix/streaming watch parties.

### Prerequisites

- Oracle Cloud free-tier account with an Ampere A1 instance (Ubuntu 22.04 or later recommended)
- Docker and Docker Compose installed on the instance
- A domain or the instance's public IP address

### 1. Install Docker

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker
```

### 2. Open the required ports

WebRTC requires both a TCP port for the web UI and a UDP port range for media. You must open these in **two places** on Oracle Cloud — the OCI Security List and the instance firewall.

**OCI Console (Security List / Network Security Group):**

Log into the OCI Console → Networking → Virtual Cloud Networks → your VCN → Security Lists → Default Security List. Add ingress rules:

| Protocol | Port range | Description |
|---|---|---|
| TCP | 8080 | Neko web UI |
| UDP | 52000–52100 | WebRTC media |

**Instance firewall (iptables / ufw):**

```bash
# If using ufw
sudo ufw allow 8080/tcp
sudo ufw allow 52000:52100/udp

# If using iptables directly
sudo iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
sudo iptables -I INPUT -p udp --dport 52000:52100 -j ACCEPT
sudo netfilter-persistent save
```

> Oracle Cloud instances block traffic at the kernel iptables level by default, independently of the Security List. You need both.

### 3. Clone the repository and build the image

```bash
git clone https://github.com/m1k1o/neko.git
cd neko

# Build the ARM64 Chromium image with Widevine
# (~500 MB download for the ChromeOS LaCrOS image, expect 10–20 min)
docker build \
  --platform linux/arm64 \
  -t neko-chromium-arm64 \
  -f apps/chromium/Dockerfile \
  --build-arg BASE_IMAGE=ghcr.io/m1k1o/neko/base:latest \
  apps/chromium/
```

### 4. Configure docker-compose.yaml

Create a `docker-compose.yaml` (or edit the existing one) with your public IP and strong passwords:

```yaml
services:
  neko:
    image: neko-chromium-arm64
    restart: unless-stopped
    shm_size: "2gb"
    ports:
      - "8080:8080"
      - "52000-52100:52000-52100/udp"
    environment:
      NEKO_DESKTOP_SCREEN: 1920x1080@30
      NEKO_MEMBER_MULTIUSER_USER_PASSWORD: "change-me"
      NEKO_MEMBER_MULTIUSER_ADMIN_PASSWORD: "change-me-admin"
      NEKO_WEBRTC_EPR: 52000-52100
      NEKO_WEBRTC_ICELITE: 1
      NEKO_NAT1TO1: "YOUR_PUBLIC_IP"   # <-- required for WebRTC from cloud
```

Get your public IP:

```bash
curl -s ifconfig.me
```

### 5. Start neko

```bash
docker compose up -d
docker compose logs -f   # watch for startup errors
```

### 6. Access and use

Open `http://YOUR_PUBLIC_IP:8080` in a browser. Log in with the admin password to control the session, or share the user password with your watch party guests.

For Netflix: navigate to `https://netflix.com` inside the neko browser, sign in, and play. Widevine will be used automatically for DRM-protected content. Your guests see the same stream in real time.

### Troubleshooting

| Symptom | Fix |
|---|---|
| Page loads but video is black / no audio | Check `NEKO_NAT1TO1` is set to your real public IP |
| Can't reach port 8080 | Verify both the OCI Security List and iptables rules are open |
| Netflix says "this browser does not support DRM" | Confirm the Widevine install succeeded: `docker exec <container> ls /usr/lib/chromium/WidevineCdm/` |
| Build fails at `unsquashfs` | The ChromeOS LaCrOS image is ~500 MB; ensure the instance has at least 2 GB free disk during build |
| Want to update Widevine version | Pass `--build-arg LACROS_VERSION=<new_version>` and rebuild |

---

## Custom Frontend Deployment (watch.chibbluffy.fyi)

This repo contains a customised chat UI on top of the upstream neko image. Changes include: individual chat bubbles in overlay mode, inline GIF/image rendering, a GIF picker powered by GIPHY, a minimisable floating chat panel, and various icon/UX tweaks.

The built frontend replaces `/var/www` inside the container. The approach is to build a thin custom Docker image that layers on top of the upstream neko image — no volume mounts needed.

### Prerequisites

`client/.env` must contain your GIPHY API key (baked into the JS bundle at build time):

```
VUE_APP_GIPHY_API_KEY=your_key_here
```

Get a free key at [developers.giphy.com](https://developers.giphy.com). This file is gitignored via `*.env`.

### 1. Build the frontend

```powershell
cd client
npm install       # only needed after dependency changes
npm run build
cd ..
```

Output goes to `client/dist/`.

### 2. Build the custom Docker image

`Dockerfile.custom` at the project root layers the built frontend into the upstream image:

```dockerfile
FROM ghcr.io/m1k1o/neko/nvidia-google-chrome:latest
COPY client/dist /var/www
```

Build it (run from the project root):

```powershell
docker build -f Dockerfile.custom -t neko-custom .
```

### 3. Update docker-compose.yaml

Change the `image:` line in your compose file:

```yaml
services:
  neko:
    image: neko-custom   # was: ghcr.io/m1k1o/neko/nvidia-google-chrome:latest
```

Everything else (GPU config, passwords, WebRTC settings, volumes) stays the same.

### 4. Restart the container

```powershell
docker compose up -d
```

### Updating after frontend changes

```powershell
cd client && npm run build && cd ..
docker build -f Dockerfile.custom -t neko-custom .
docker compose up -d
```
