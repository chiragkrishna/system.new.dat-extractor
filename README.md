# Auto System Image Extractor

A lightweight utility designed to automate the extraction of Android system images. This tool handles the conversion process from various compressed formats into raw, editable files.

---

### 🚀 Supported Formats

The extractor currently supports:

1. **system.new.dat** (Legacy Android ROMs)
2. **system.new.dat.br** (Brotli compressed images)
3. **payload.bin** (Modern A/B partition OTA updates)

---

### 📋 Requirements

To run this tool, ensure the following are installed and added to your **System Environment Variables (PATH)**:

- **[Python v3.x](https://www.python.org/downloads/)**
- **[7-Zip](http://www.7-zip.org/download.html)**
- **[Brotli](https://github.com/google/brotli)**

---

### 🛠 How To Use

1.  **Extract** `system_new_dat_extractor.zip` into a new folder.
    - ⚠️ \_Important: Use a path without spaces
2.  **Place** your target ROM zip file into the same directory where you extracted the tool.
3.  **Run** `system_image_extractor_V6.sh`.
4.  **Wait** for the script to finish processing the files.
5.  **Finish:** The folder containing the extracted content will open automatically.

> **Warning:** Sudo Required to mount the .img and copy files.

> **Pro Tip:** Always delete the previously created output folders before starting a new extraction to avoid data corruption.

---

### 📜 Change-log

| Version | Highlights                                                                             |
| :------ | :------------------------------------------------------------------------------------- |
| **V6**  | Moved to Linux bash script (Problems with symlinks in windows)                         |
| **V5**  | Entire script rewrite                                                                  |
| **V4**  | Entire script rewrite; fixed path issues where spaces caused unintended file deletion. |
| **V3**  | Added support for `system.new.dat`, `system.new.dat.br`, and `payload.bin`.            |
| **V2**  | Added Nougat support; converts `file_contexts.bin` to `file_contexts`.                 |
| **V1**  | Initial release.                                                                       |

---

### 🤝 Credits

- **And_pda** - imgextractor
- **[xpirt](http://forum.xda-developers.com/member.php?u=5361113)** - sdat2img.py
- **[cyxx](https://github.com/cyxx/extract_android_ota_payload)** - payload extraction logic
- **[@aIecxs](https://forum.xda-developers.com/member.php?u=7285913)** & **ius**
- **Google** - Android platform tools
- **[@sekaiacg](https://github.com/sekaiacg/erofs-utils)** - erofs-utils
