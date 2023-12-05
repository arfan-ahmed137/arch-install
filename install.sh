#! /bin/bash

echo "Welcome to arch installtion helper"
echo "\nIf you haven't partitioned the disk yet, please partition it first\nOnce partitioned edit the variables in the .config file\nONLY THEN THIS SCRIPT WILL WORK"

function setup_partitions(){
  local BOOR_PART=${1}
  local ROOT_PART={$2}
  local SWAP_PART={$3}

  echo "Formatting Partition"
  mkfs.ext4 "${ROOT_PART}"
  mkfs.fat -F 32 "${BOOT_PART}"
  mkswap "${SWAP_PART}"

  echo "Mounting Root"
  mount "${ROOT_PART}" /mnt
  
  echo "Mounting Boot"
  mkdir -p /mnt/boot
  mount "${BOOT_PART}" /mnt/boot
  
  if [-n "${SWAP_PART}"]; then
    echo "Enabling Swap at ${SWAP_PART}"
    swapon "${SWAP_PART}"
}

function main(){
  source .config

  setfont sun12x12

  echo "I hope you are connected to the internet\nIf not please exit the script connect to the internet and then run the installer again."

  pacman -Syy
  pacman -S archlinux-keyring
  pacstrap -K /mnt base linux linux-firnware sof-firmware base-devel grub efibootmgr nano networkmanager zsh git
  
  echo "Generating fstab to /mnt/etc/fstab"
  genfstab /mnt > /mnt/etc/fstab
  arch-chroot /mnt 
}
