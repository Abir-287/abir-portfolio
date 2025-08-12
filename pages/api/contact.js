export default async function handler(req, res) {
  if (req.method !== "POST") return res.status(405).json({ error: "Method not allowed" });

  try {
    const { name, email, subject, message } = req.body || {};
    if (!name || !email || !subject || !message) {
      return res.status(400).json({ error: "Missing fields" });
    }

    const access_key = process.env.WEB3FORMS_KEY;
    if (!access_key) return res.status(500).json({ error: "Missing WEB3FORMS_KEY in .env.local" });

    // Map your "subject" -> Web3Forms "_subject" so it sets the email subject line
    const body = new URLSearchParams({
      access_key,
      name,
      email,
      message,
      _subject: subject,     // <-- THIS sets the actual email subject
      // keep original subject in body too (optional, helps in templates)
      subject,
    }).toString();

    const r = await fetch("https://api.web3forms.com/submit", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        Accept: "application/json",
      },
      body,
    });

    const data = await r.json().catch(() => ({}));
    if (!r.ok || data?.success === false) {
      return res.status(502).json({ error: data?.message || `Web3Forms error (HTTP ${r.status})`, provider: data });
    }

    return res.status(200).json({ ok: true });
  } catch (e) {
    console.error("Contact proxy error:", e);
    return res.status(500).json({ error: "Server error" });
  }
}
