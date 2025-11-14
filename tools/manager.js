import * as WebLLM from "./webllm.js";
import * as APIModel from "./api.js";
import * as Ollama from "./ollama.js";

export class ModelManager {
  constructor() {
    this.current = null;
  }

  async load(modelCfg) {
    if (modelCfg.type === "webllm") {
      this.current = await WebLLM.load(modelCfg);
    } else if (modelCfg.type === "api") {
      this.current = APIModel.create(modelCfg);
    } else if (modelCfg.type === "ollama") {
      this.current = Ollama.create(modelCfg);
    }
  }

  async send(msg) {
    return await this.current.send(msg);
  }
}
