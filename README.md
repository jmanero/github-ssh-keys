GitHub SSH Keys
===============

Manage `authorized_keys` from a github account

## Installation

Be dangerous.

```
curl -Ssl https://jmanero.github.io/github-ssh-keys/install-me.sh | bash
```

## Usage

> **NOTE**
> A GitHub account must exist with the same name as the UNIX account being managed

* Update the current user's `authorized_keys`:

  ```
  github-ssh-keys
  ```

* Update another user's `authorized_keys`:

  ```
  github-ssh-keys somebody-else
  ```

### Or with systemd...

```
sudo systemctl enable --now github-ssh-keys@$USER.timer github-ssh-keys@$USER.service
```

This will check for updates every 30-90 minutes, and at system startup. To monitor the timer unit:

```
$ sudo systemctl status github-ssh-keys@$USER.timer 
● github-ssh-keys@YOUR-USER.timer - Timer to update YOUR-USER's SSH authorized-keys from their github account
    Loaded: loaded (/etc/systemd/system/github-ssh-keys@.timer; enabled; preset: disabled)
    Active: active (waiting) since Sun 2023-12-10 00:48:47 UTC; 1h 51min ago
   Trigger: Sun 2023-12-10 03:05:33 UTC; 25min left
  Triggers: ● github-ssh-keys@YOUR-USER.service
      Docs: https://github.com/jmanero/github-ssh-keys
```
