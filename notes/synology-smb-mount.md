# Mounting the Synology NAS (CloudNine) over SMB

Use SMB, not AFP.

## Restoring after a system wipe (read this first)

`/home` lives on a separate drive and survives a reinstall. `/etc` does not, so
`/etc/fstab` and the cifs-utils package are lost. The credentials file is kept
in `/home` so it survives too.

Checklist:

1. Reinstall Ubuntu, keeping the same username (`ryan`, uid/gid 1000) and
   re-mounting the existing /home drive (add it to /etc/fstab first).
   If the new uid is not 1000, change `uid=`/`gid=` in the fstab line below.
2. Install the tools and create the mount point:
   ```
   sudo apt install cifs-utils
   sudo mkdir -p /mnt/backups
   ```
3. Confirm the credentials file still exists and is private:
   ```
   ls -l /home/ryan/.smb-nas-credentials     # should be -rw------- ryan
   chmod 600 /home/ryan/.smb-nas-credentials
   ```
   If it is missing, recreate it (see "Credentials file" below).
4. Re-add the fstab line and activate it:
   ```
   echo '//CloudNine.local/backups /mnt/backups cifs credentials=/home/ryan/.smb-nas-credentials,uid=1000,gid=1000,iocharset=utf8,vers=3.0,_netdev,nofail,x-systemd.automount 0 0' | sudo tee -a /etc/fstab
   sudo systemctl daemon-reload
   sudo mount -a
   ls /mnt/backups
   ```
5. Optional: re-bookmark `/mnt/backups` in Files (Ctrl+D inside the folder).

## Credentials file

Location: `/home/ryan/.smb-nas-credentials` (NOT inside the dotfiles repo, so the
password is never committed or pushed).

```
username=Ryan
password=YOUR_PASSWORD
```

```
chmod 600 /home/ryan/.smb-nas-credentials
```

Root reads it at mount time. Do not copy it into ~/Workbench/dotfiles.

## Quick mount (GNOME Files)

1. Files -> Other Locations -> "Connect to Server"
2. Enter `smb://CloudNine.local/backups` (fallbacks: `smb://CloudNine/backups`, or the NAS IP)
3. Log in as `Ryan`, choose "Remember forever"
4. Drag the folder to the sidebar to bookmark it

Mount appears at `/run/user/1000/gvfs/smb-share:server=cloudnine.local,share=backups`.

### Check it is SMB, not AFP

```
gio mount -l | grep -i smb
ls /run/user/1000/gvfs/
```

Entries starting `afp-volume:` are the old mount. Unmount with:

```
gio mount -u "afp://Ryan@CloudNine.local/backups"
```

## Permanent mount, first-time setup (/etc/fstab, CIFS)

Gives a normal path at `/mnt/backups` that survives reboots.

```
sudo apt install cifs-utils
sudo mkdir -p /mnt/backups
nano /home/ryan/.smb-nas-credentials     # contents above
chmod 600 /home/ryan/.smb-nas-credentials
sudo cp /etc/fstab /etc/fstab.bak
echo '//CloudNine.local/backups /mnt/backups cifs credentials=/home/ryan/.smb-nas-credentials,uid=1000,gid=1000,iocharset=utf8,vers=3.0,_netdev,nofail,x-systemd.automount 0 0' | sudo tee -a /etc/fstab
sudo systemctl daemon-reload
sudo mount -a
```

Options:

- `uid=1000,gid=1000`: files appear owned by me, no sudo needed
- `vers=3.0`: SMB3. Needs DSM Maximum SMB protocol raised (it was set low originally, which gave mount error 95 on 3.0)
- `nofail`, `_netdev`: do not hang boot if the NAS is off or the network is down
- `x-systemd.automount`: mount on first access (also avoids ordering problems
  with /home being on a separate drive)

### Verify

```
ls "/mnt/backups/Household Finances/2026/OnPoint"
findmnt /mnt/backups
```

With automount, `findmnt` may show only the automount entry until something
touches the folder; after the `ls` it shows a `cifs` entry.

## Troubleshooting

- `dmesg | tail -20` for the real error
- `mount error(13)`: wrong credentials
- `mount error(112)` / "Host is down": hostname not resolving; use the NAS IP
  and give it a DHCP reservation on the router
- Undo: `sudo cp /etc/fstab.bak /etc/fstab`

## Undeletable files on the NAS

If files will not delete from a mount (even with sudo), delete them from DSM
File Station, or over SSH on the NAS (`ls -lab` shows real names;
`sudo rm -v -- 'name'`). Note: sudo cannot see into GVFS FUSE mounts.

## SMB version note

`mount error(95): Operation not supported` means the `vers=` value is not
accepted by the NAS. On 2026-11-11 `vers=3.0` failed and `vers=2.0` worked
until I raised DSM Control Panel -> File Services -> SMB -> Advanced Settings
-> Maximum SMB protocol. After that `vers=3.0` works. If it ever returns, check
that DSM setting first, and test by hand with
`sudo mount -t cifs ... -o vers=3.0` before editing fstab.
