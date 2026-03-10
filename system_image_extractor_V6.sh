#!/bin/bash

# --- Configuration ---
TOOLS_DIR="./tools"
TEMP_DIR="./temp_files"
EXTRACT_DIR="./extracted_files"
ROM_TEMP="$TEMP_DIR/rom"

# Function to check for required tools
check_dependencies() {
    for tool in 7z brotli python3; do
        if ! command -v $tool &> /dev/null; then
            echo "[ERROR] $tool is not installed. Run: sudo apt install p7zip-full brotli python3"
            exit 1
        fi
    done
}

clear
echo "==========================================================="
echo "   Android ROM Extractor - Linux Edition"
echo "==========================================================="
check_dependencies

# Create/Clean directories
rm -rf "$TEMP_DIR" "$EXTRACT_DIR"
mkdir -p "$ROM_TEMP" "$EXTRACT_DIR"

# --- File Validation ---
zip_file=$(ls *.zip 2>/dev/null | head -n 1)
if [ -z "$zip_file" ]; then
    echo "[ERROR] No ROM .zip detected."
    exit 1
fi

echo "[*] Extracting ROM: $zip_file"
"$TOOLS_DIR/7z" e "$zip_file" -o"$ROM_TEMP" -y > /dev/null

# --- Processing Branch ---
if [ -f "$ROM_TEMP/payload.bin" ]; then
    echo "[*] Payload detected. Dumping..."
    # Ensure you have a linux-compatible payload-dumper
    python3 "$TOOLS_DIR/payload_dumper.py" "$ROM_TEMP/payload.bin" --out "$ROM_TEMP"
    FINAL_IMG_DIR="$ROM_TEMP"

elif [ -f "$ROM_TEMP/system.new.dat.br" ]; then
    echo "[*] Brotli detected. Decompressing..."
    brotli -d "$ROM_TEMP/system.new.dat.br" -o "$ROM_TEMP/system.new.dat"
    [ -f "$ROM_TEMP/vendor.new.dat.br" ] && brotli -d "$ROM_TEMP/vendor.new.dat.br" -o "$ROM_TEMP/vendor.new.dat"

    echo "[*] Converting .dat to .img..."
    python3 "$TOOLS_DIR/sdat2img.py" "$ROM_TEMP/system.transfer.list" "$ROM_TEMP/system.new.dat" "$ROM_TEMP/system.img"
    [ -f "$ROM_TEMP/vendor.new.dat" ] && python3 "$TOOLS_DIR/sdat2img.py" "$ROM_TEMP/vendor.transfer.list" "$ROM_TEMP/vendor.new.dat" "$ROM_TEMP/vendor.img"
    FINAL_IMG_DIR="$ROM_TEMP"
fi

# --- Final Extraction (Handling EROFS/EXT4) ---
extract_logic() {
    local img="$1"
    local name="$2"
    if [ -f "$img" ]; then
        echo "[>] Extracting $name..."
        mkdir -p "$EXTRACT_DIR/$name"

        # Method 1: Use Linux Native Mount (Best for avoiding 'Bad Magic' or 'Superblock' errors)
        # Note: Requires sudo for loop device mounting
        sudo mount -o loop "$img" /mnt 2>/dev/null
        if [ $? -eq 0 ]; then
            sudo cp -a /mnt/. "$EXTRACT_DIR/$name/"
            sudo umount /mnt
            echo "[+] $name extracted via mount."
        else
            # Method 2: Fallback to extract.erofs if mount fails
            "$TOOLS_DIR/extract.erofs" -i "$img" -x -o "$EXTRACT_DIR/$name" -f
        fi
    fi
}

extract_logic "$FINAL_IMG_DIR/system.img" "system"
extract_logic "$FINAL_IMG_DIR/vendor.img" "vendor"

echo "==========================================================="
echo "   PROCESS COMPLETE!"
echo "==========================================================="