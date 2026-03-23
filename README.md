# OpenSign

One-click deploy of [OpenSign](https://www.opensignlabs.com/) on Railway — an open-source alternative to DocuSign for digital document signing.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/template/TEMPLATE_CODE)

## Services Included

- **OpenSign Server** — Node.js/Express backend API (Parse Server + MongoDB) on port 8080
- **OpenSign Client** — React frontend on port 3000
- **MongoDB** — Database for documents, users, and signing data

## Architecture

OpenSign is a MERN stack application. On Railway, each service gets its own domain (no reverse proxy needed). The client talks directly to the server's public URL. The server connects to MongoDB for data persistence and stores uploaded files locally in a volume.

```
Client (React, :3000) --https--> Server (Node.js/Express, :8080) --> MongoDB (:27017)
```

## Environment Variables

### Server

| Variable | Description | Default |
|----------|-------------|---------|
| `APP_ID` | Parse Server application ID | `opensign` (must not change) |
| `MASTER_KEY` | Parse Server master key (keep secret) | Auto-generated |
| `MONGODB_URI` | MongoDB connection string | Auto-configured via reference |
| `SERVER_URL` | Internal server URL for Parse Server | Auto-configured |
| `PUBLIC_URL` | Public-facing URL of the application | Set to client domain |
| `appName` | Application name for emails | `OpenSign™` |
| `USE_LOCAL` | Use local file storage instead of S3 | `true` |
| `SMTP_ENABLE` | Enable SMTP for email sending | `false` |
| `SMTP_HOST` | SMTP server hostname | _(optional)_ |
| `SMTP_PORT` | SMTP server port | _(optional)_ |
| `SMTP_USER_EMAIL` | SMTP authentication email | _(optional)_ |
| `SMTP_PASS` | SMTP authentication password | _(optional)_ |

### Client

| Variable | Description | Default |
|----------|-------------|---------|
| `REACT_APP_SERVERURL` | URL of the backend API | Auto-configured via reference |
| `REACT_APP_APPID` | Parse Server app ID (must match server) | `opensign` (must not change) |
| `PUBLIC_URL` | Public URL of the frontend | Auto-configured |

## Volumes

- **Server**: `/usr/src/app/files` — Stores uploaded documents and signed PDFs

## Important Notes

- **Do not change `APP_ID`**: The pre-built client Docker image has `REACT_APP_APPID=opensign` baked in at build time. The server's `APP_ID` must remain `opensign` or all API requests will fail with 401 Unauthorized.
- **MongoDB startup**: The server waits for MongoDB to become reachable before starting Parse Server, preventing crash loops during initial deployment.

## Post-Deployment

1. Visit your client service's public URL
2. Create an account to get started
3. Upload a document and add signature fields
4. Send for signing via email (requires SMTP configuration)

## Optional: Email Setup

To enable email notifications for signature requests, set the SMTP variables on the server service:
- `SMTP_ENABLE=true`
- `SMTP_HOST`, `SMTP_PORT`, `SMTP_USER_EMAIL`, `SMTP_PASS`

Alternatively, use Mailgun by setting `MAILGUN_API_KEY`, `MAILGUN_DOMAIN`, and `MAILGUN_SENDER`.

## Optional: S3/Object Storage

By default, files are stored locally on the server volume. For production use with S3-compatible storage:
- Set `USE_LOCAL=false`
- Configure `DO_SPACE`, `DO_ENDPOINT`, `DO_BASEURL`, `DO_ACCESS_KEY_ID`, `DO_SECRET_ACCESS_KEY`, `DO_REGION`

## Links

- [OpenSign GitHub](https://github.com/OpenSignLabs/OpenSign)
- [OpenSign Documentation](https://docs.opensignlabs.com/)
- [OpenSign Website](https://www.opensignlabs.com/)
