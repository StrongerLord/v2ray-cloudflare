# V2Ray Proxy via Cloudflare Tunnel

Bypass network restrictions using V2Ray VMess protocol over Cloudflare Tunnel. Works with free Cloudflare tier.

## What's this?

A proxy server that lets you access blocked websites (Facebook, Instagram, etc.) from restrictive networks. Uses V2Ray VMess over WebSocket, which is basically invisible to DPI and firewalls since it looks like regular HTTPS traffic.

## Why V2Ray + Cloudflare?

- Works with Cloudflare's **free** tunnel (no need for paid TCP tunnels)
- Traffic looks like normal HTTPS, impossible to detect
- Compatible with popular mobile apps (Shadowrocket, V2RayNG)
- Actually fast

## Requirements

- A server with Docker installed
- Cloudflare account with a domain
- That's it

## Setup

### 1. Clone this repo

```bash
git clone https://github.com/StrongerLord/v2ray-cloudflare.git
cd proxy-nginx
```

### 2. Create Cloudflare Tunnel

Go to https://one.dash.cloudflare.com/ and:

1. **Networks → Tunnels → Create a tunnel**
2. Give it a name (whatever you want)
3. Copy the **token** they give you (long string starting with `eyJ...`)
4. Click **Next** and configure public hostname:
    - **Subdomain**: pick one (e.g., `proxy`)
    - **Domain**: your domain
    - **Service**: `HTTP`
    - **URL**: `proxy-salida:8080` (this is the internal container name and port)
5. Save

The important part here is setting the URL to `proxy-salida:8080` - that's how Cloudflare reaches your proxy container.

### 3. Configure environment

```bash
cp .env.example .env
nano .env
```

Edit `.env` with your values:

```bash
TUNNEL_TOKEN=<paste-the-token-from-step-2>
V2RAY_UUID=<generate-a-new-uuid>
```

For UUID, go to https://www.uuidgenerator.net/ and generate a new one. This is basically your password.

### 4. Start everything

```bash
docker-compose up -d --build
```

Check logs to make sure it's running:

```bash
docker logs proxy-salida -f
```

You should see V2Ray starting up and accepting connections.

## Client Setup

### Shadowrocket (iOS - $2.99)

Best option for iOS. Here's what you need:

- **Type**: VMess
- **Address**: your-subdomain.yourdomain.com (from step 2)
- **Port**: `443`
- **UUID**: the UUID from your `.env` file
- **AlterID**: `0`
- **Security**: `auto`
- **Network**: `ws`
- **Path**: `/wywb`
- **TLS**: ON (required)
- **SNI**: your-subdomain.yourdomain.com

### V2RayNG (Android - Free)

Free alternative for Android:

1. Install from Play Store or GitHub
2. Add server manually (VMess)
3. Same config as above
4. Connect

### Other clients

- **V2RayN** (Windows)
- **Qv2ray** (cross-platform)
- **V2Box** (Android)

All use the same config.

## Testing

From your phone/device:

1. Connect using your client app
2. Visit https://ifconfig.me or https://ipinfo.io
3. Should show your server's IP, not your real IP
4. Try accessing blocked sites

From server:

```bash
docker logs proxy-salida -f
```

You'll see requests going through if it's working.

## Security Notes

**Keep private:**

- Your `.env` file (has credentials)
- Your UUID (it's your password basically)

**Recommendations:**

- Change UUID every few months
- Don't share your config with random people
- Monitor logs occasionally

**Adding more users:**

Edit the UUID in `Dockerfile` to include multiple clients:

```json
"clients": [
  {"id": "uuid-for-user1", "alterId": 0},
  {"id": "uuid-for-user2", "alterId": 0}
]
```

Then rebuild: `docker-compose up -d --build`

## Troubleshooting

**Can't connect from phone:**

- Make sure TLS is enabled in your app
- Check that UUID matches exactly
- Verify path is `/wywb` (with the slash)
- Confirm tunnel is "Healthy" in Cloudflare dashboard

**No traffic going through:**

```bash
docker logs proxy-salida -f
```

If you don't see any requests, double-check your client config.

**Tunnel not connecting:**

```bash
docker logs cloudflared-tunnel
```

Usually means wrong token or Cloudflare having issues.

## Tech Details

- **Protocol**: VMess over WebSocket
- **Encryption**: Auto (AES-128-GCM)
- **Port**: 8080 internal, 443 external via Cloudflare
- **WebSocket path**: `/wywb`
- **Image**: v2fly/v2fly-core

## Notes

- Uses Cloudflare's free tier (no TCP tunnel needed)
- Traffic is indistinguishable from regular HTTPS
- Works through most DPI systems
- `.env` is gitignored, don't commit it

## Disclaimer

For educational purposes. Make sure you're not violating any policies or laws in your area.
