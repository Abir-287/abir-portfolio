import { DefaultAzureCredential } from "@azure/identity";
import { SecretClient } from "@azure/keyvault-secrets";

export default async function handler(req, res) {
  if (req.method !== "POST") {
    return res.status(405).json({ error: "Method not allowed" });
  }

  const { name, email, subject, message, botcheck } = req.body;
  
  // Validate required fields
  if (!name || !email || !subject || !message) {
    return res.status(400).json({ error: "Missing required fields" });
  }
  
  // Basic bot check
  if (botcheck) {
    return res.status(400).json({ error: "Bot detected" });
  }

  try {
    let accessKey = process.env.WEB3FORMS_KEY;

    // Only try Azure Key Vault in production if local env var is not set
    if (!accessKey && process.env.NODE_ENV === "production") {
      console.log("Attempting to fetch key from Azure Key Vault...");
      
      if (!process.env.KEY_VAULT_NAME) {
        throw new Error("KEY_VAULT_NAME environment variable is required in production");
      }

      const vaultUrl = `https://${process.env.KEY_VAULT_NAME}.vault.azure.net`;
      const credential = new DefaultAzureCredential();
      const client = new SecretClient(vaultUrl, credential);
      const secret = await client.getSecret("web3forms-key");
      accessKey = secret.value;
    }

    if (!accessKey) {
      throw new Error("WEB3FORMS_KEY is not set. Please add it to your environment variables.");
    }

    const formData = {
      access_key: accessKey,
      name,
      email,
      subject,
      message
    };

    const response = await fetch("https://api.web3forms.com/submit", {
      method: "POST",
      headers: { 
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: JSON.stringify(formData),
    });

    const result = await response.json();
    
    if (response.ok && result.success) {
      return res.status(200).json({ 
        success: true, 
        message: "Email sent successfully" 
      });
    } else {
      console.error("Web3Forms error:", result);
      return res.status(500).json({ 
        error: "Failed to send email", 
        details: result 
      });
    }
  } catch (error) {
    console.error("Server error:", error);
    return res.status(500).json({ 
      error: "Internal server error",
      message: error.message 
    });
  }
}