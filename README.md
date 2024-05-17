# PenPals

A Simple PenTesting Marketplace

# How It Works

1. Log into a machine you control and install `socat`:

```bash
# Debian/Ubuntu
sudo apt install socat

# Fedora/CentOS 8/RHEL 8
sudo dnf install socat

# CentOS/RHEL
sudo yum install socat

# Arch Linux
sudo pacman -S socat

# openSUSE
sudo zypper install socat

# Gentoo
sudo emerge net-misc/socat

# Alpine
sudo apk add socat 
```

2. Install the PenPal Verifier and make sure port 8080 is publically accessible

```
curl -o- https://raw.githubusercontent.com/hypercrowd/penpals/v1.0.0/penpals.sh | bash
```

The PenPal Verifier does the following:

* Generates a proof for the peneration tester to get.  This proof is used to prove the tester was succcessful.  This proof will be stored in `/tmp/proof`
* Runs a simple HTTP server using `socat` to verify that you own the machine.  We will communicate with this server to verify you have access to the machine.  The HTTP server will shut down after we complete verification.
* Generates a link for you to put your machine onto [the marketplace](https://airtable.com/apppJsMZ2MAT6iLkN/shrXaJPGtOLDB7jRM/tblwVDav3AGPbYY7B)

3. A penetration tester will take on jobs in [the marketplace](https://airtable.com/apppJsMZ2MAT6iLkN/shrXaJPGtOLDB7jRM/tblwVDav3AGPbYY7B) and will try to get access to `/tmp/proof`

4. `/tmp/proof` will have a link the tester uses to prove they penetrated the system.  They will then submit their email address and how they penetrated the system.

5. You pay to get access to how they penetrated the system.

## Safety Tips

* Make sure the machine is closed off to the rest of your network
* Make sure the machine has no credentials or code on it that you don't want leaked
* The machine should be completely virtualized and should only be configured in a way that exposes only a part of your security loadout.
* Be paranoid because the penetration tester should _**NEVER**_ be trusted
* _**We are not responsible for stolen data, compromised networks, or undesired applications being installed on your machine!**_