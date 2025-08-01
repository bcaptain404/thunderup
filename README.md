# thunderup

A Bash script that auto-checks Thunderbird's official website for new releases, downloads the latest version, extracts it to `/opt/thunderbird`, and launches it.

Use this when you want to skip package managers and manage Thunderbird updates manually without missing new releases.

---

## 📁 What It Does

- Checks [thunderbird.net](https://www.thunderbird.net/) for the latest release version (unless provided explicitly)
- Downloads the correct archive (`tar.bz2` or `tar.xz`) if a new version is available
- Extracts Thunderbird to `/opt/thunderbird`
- Prevents redundant installs by tagging completed versions
- Automatically launches Thunderbird when done

---

## 🛠 Installation

1. Copy `update-thunderbird.sh` to any directory in your `$PATH` (e.g., `/usr/local/bin/`)
2. Make it executable:

```bash
chmod +x /path/to/update-thunderbird.sh
```

3. (Optional) Rename it to something simpler like `thunderup`

---

## 🔧 Usage

```bash
./update-thunderbird.sh [version]
```

- If no version is given, it automatically queries the Thunderbird website for the latest.
- If you supply a version manually (e.g., `115.2.0`), it attempts to install that directly.

---

## 🔍 Example

```bash
./update-thunderbird.sh
# or
./update-thunderbird.sh 115.2.0
```

---

## 📂 Files Used

- `/opt/thunderbird` – Where Thunderbird is extracted
- `../downloads/` – Download cache (sibling to `/opt/thunderbird`)
- Tag files like `thunderbird_installed.115.2.0` prevent unnecessary reinstalls

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
- The script does not currently launch Thunderbird itself; it simply ensures it’s installed and ready.

---

## 📜 License

See [LICENSE](./LICENSE)

---

## ✨ Why?

Because Mozilla doesn’t ship `.deb` files, and package managers are either outdated or annoying. This script gives you full control over your Thunderbird install with minimal effort.

