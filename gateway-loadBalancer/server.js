const http = require("http");
const httpProxy = require("http-proxy");
const dotenv = require("dotenv");

dotenv.config();

const GATEWAY_PORT = Number(process.env.GATEWAY_PORT || 3000);
const PROXY_TIMEOUT_MS = Number(process.env.PROXY_TIMEOUT_MS || 4000);

const BACKEND_TARGETS = (process.env.BACKEND_TARGETS || "")
  .split(",")
  .map(s => s.trim())
  .filter(Boolean);

const COMMENT_SERVICE = (process.env.COMMENT_SERVICE || "").trim();

if (BACKEND_TARGETS.length === 0) {
  console.error("BACKEND_TARGETS kosong. Isi minimal 1 target backend.");
  process.exit(1);
}
if (!COMMENT_SERVICE) {
  console.error("COMMENT_SERVICE kosong. Isi URL comment service.");
  process.exit(1);
}

const proxy = httpProxy.createProxyServer({
  xfwd: true, // X-Forwarded-For/Host/Proto
  proxyTimeout: PROXY_TIMEOUT_MS,
  timeout: PROXY_TIMEOUT_MS
});

// Simple health tracking biar kalau satu node mati, tidak bikin semua request ikut mati.
const health = new Map(); // target -> { downUntil: timestamp }
for (const t of BACKEND_TARGETS) health.set(t, { downUntil: 0 });

let rrIndex = 0;
function pickBackendTarget() {
  const now = Date.now();
  // coba maksimal N target untuk cari yang tidak down
  for (let i = 0; i < BACKEND_TARGETS.length; i++) {
    const idx = (rrIndex + i) % BACKEND_TARGETS.length;
    const t = BACKEND_TARGETS[idx];
    const h = health.get(t);
    if (!h || h.downUntil <= now) {
      rrIndex = (idx + 1) % BACKEND_TARGETS.length;
      return t;
    }
  }
  // kalau semua dianggap down, fallback ke round-robin biasa
  const t = BACKEND_TARGETS[rrIndex % BACKEND_TARGETS.length];
  rrIndex = (rrIndex + 1) % BACKEND_TARGETS.length;
  return t;
}

function routeTarget(reqUrl) {
  // Routing paling “kelihatan” untuk demo:
  // 2) comment service
  if (reqUrl.startsWith("/komentar")) return COMMENT_SERVICE;

  // 3) sisanya ke backend pool
  return pickBackendTarget();
}

function setServedByHeader(res, target) {
  // Biar kamu bisa demo “request ini dilayani siapa”
  res.setHeader("X-Served-By", target);
}

const server = http.createServer((req, res) => {
  const target = routeTarget(req.url);

  setServedByHeader(res, target);

  // Health hint: kalau target backend error, tandai down sebentar (5 detik)
  proxy.web(req, res, { target }, (err) => {
    // error handler fallback
    if (target && BACKEND_TARGETS.includes(target)) {
      health.set(target, { downUntil: Date.now() + 5000 });
    }

    res.writeHead(502, { "Content-Type": "application/json" });
    res.end(JSON.stringify({
      status: 502,
      message: "Bad Gateway",
      detail: err ? err.message : "Proxy error",
      target
    }));
  });
});

proxy.on("proxyRes", (proxyRes, req, res) => {
  // Bisa tambahin header tracing kalau mau
  // proxyRes.headers["x-gateway"] = "gateway-loadbalancer";
});

server.listen(GATEWAY_PORT, () => {
  console.log(`Gateway running at http://localhost:${GATEWAY_PORT}`);
  console.log(`Backend targets: ${BACKEND_TARGETS.join(", ")}`);
  console.log(`Comment service: ${COMMENT_SERVICE}`);
});
