# thunderup

A Bash script that auto-checks Thunderbird's official website for new releases, downloads the latest version if it's newer than the one you're running, extracts it to `/opt/thunderbird`, and optionally installs a specific version by tag.

Use this when you want to skip package managers and manage Thunderbird updates more efficiently. Bonus: wrap it in a launcher to check for updates before every run.

---

## 📁 What It Does

- Queries [thunderbird.net](https://www.thunderbird.net/) for the latest release (if version not provided)
- Downloads the `.tar.bz2` or `.tar.xz` archive (whichever is available)
- Extracts it to `/opt/thunderbird`
- Skips reinstallation if already installed
- Saves downloads to `/opt/downloads/` for reuse

---

## 🛠 Installation

1. Copy `thunderup.sh` anywhere in your `$PATH`, like `/usr/local/bin/`
2. Make it executable:

```bash
chmod +x /path/to/thunderup.sh
```

3. (Optional) Symlink or rename it to something like `thunderup`

---

## 🔧 Usage

```bash
thunderup.sh [options] [version]
```

### Options

- `--help`, `-h` — Print usage help and exit
- `--check-only` — Show the latest version available, then exit

### Version Argument

- Optional. If provided (e.g., `115.2.0`), attempts to install that specific version.
- If omitted, the script checks the latest version from the website.

---

## 🔍 Examples

```bash
thunderup.sh           # Auto-detects latest version and installs if needed
thunderup.sh 115.2.0  # Installs specific version if not already installed
thunderup.sh --check-only  # Outputs latest version number and exits
```

---

## 🚫 Dependencies

- `wget`
- `tar`
- Standard GNU tools (`bash`, `realpath`, `mkdir`, `tee`)

These are typically available by default on most Linux distributions.

---

## 🚧 Notes

- The script avoids reinstalling by creating a tag file like:\
  `/opt/downloads/thunderbird_installed.115.2.0`
- To force reinstalling the same version, delete the tag file.
- Logs for each run are saved to `/tmp/thunderup.log`

---

## 📜 License

See LICENSE

---

## ✨ Why?

Because Mozilla doesn’t provide `.deb` packages, and distro repositories are often outdated. This gives you up-to-date Thunderbird on your terms, no flatpaks, snaps, or PPAs needed.

