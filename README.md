# thunderup

A Bash script that auto-checks Thunderbird's official website for new releases, downloads the latest version if it's newer than the one you're running, and extracts it to `/opt/thunderbird`.

Use this when you want to skip package managers and manage Thunderbird updates more efficiently. Bonus points: add it to a launcher script to check for and apply updates at each launch of Thunderbird

---

## 📁 What It Does

- If no version is specified as a commandline argument, it queries [thunderbird.net](https://www.thunderbird.net/) for the latest.
- Downloads the archive for that version (if it hasn't been downloaded yet) into /opt/downloads
- Extracts it to `/opt/thunderbird`
- Prevents redundant installs by tagging successful installs

---

## 🛠 Installation

1. Copy `update-thunderbird.sh` anywhere you like, eg to any directory in your `$PATH` (e.g., `/usr/local/bin/`)
2. Make it executable:

```bash
chmod +x /path/to/update-thunderbird.sh
```

---

## 🔧 Usage

```bash
./update-thunderbird.sh [version]
```

---

## 🔍 Example

```bash
./update-thunderbird.sh # download & install the latest version if we're out of date
# or
./update-thunderbird.sh 115.2.0 # download & install a specific version if that's not the one we're running
```

---

## 🚫 Dependencies

- `wget`
- `tar`
- Standard GNU userland (`bash`, `realpath`, `mkdir`, `tee`)

These are already included on most modern Linux distros.

---

## 🚧 Notes

- If the script detects the same version was already installed, it aborts with a helpful message.
- To force reinstallation, just delete the corresponding tag file in the downloads directory.

---

## 📜 License

See [LICENSE](./LICENSE)

---

## ✨ Why?

Because Mozilla doesn’t ship `.deb` files, and package managers are either outdated or annoying. I've been using and maintaining this script on a daily basis for years, so it should be fairly robust by now.

