export function create(cfg) {
  return {
    send: async (msg) => {
      const res = await fetch(`${cfg.host}/api/generate`, {
        method: "POST",
        body: JSON.stringify({ model: cfg.id, prompt: msg }),
        headers: { "Content-Type": "application/json" }
      });
      const data = await res.json();
      return data.response;
    }
  };
}
