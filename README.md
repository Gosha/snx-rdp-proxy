# SNX RDP Proxy

Sets up environment where [`snxconnect`](https://github.com/schlatterbeck/snxvpn) works.
Forwards incoming connections on port 3389 to `REMOTE_HOST`.

Usage:

- Create an `.env` file from the [example](./example.env)
- Start with

  ```sh
  docker run -p 3389:3389 --rm --name snx --privileged -it --env-file .env goshaza/snx-rdp-proxy
  ```

- Fill in password (if not in .env)
- Fill in One-time code.  
  _Note that since snxvpn uses `getpass` the input not visible_.
- Connect with RDP to localhost:3389
