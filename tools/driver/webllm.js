export async function load(cfg) {
  const engine = await webllm.createEngine(cfg.id);
  return {
    send: async msg => await engine.chat(msg)
  };
}
