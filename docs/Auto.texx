const puppeteer = require('puppeteer');

(async () => {
  // --- CONFIG ---
  const INITIAL_URL = 'https://xxxxx.localhost.mobi'; // replace with your Localhost.mobi URL
  const ITERATION_LIMIT = 20; // as requested
  const MODEL_TO_LOAD = 'llama3-8b-web'; // example, can be API or Ollama
  const XLSL_ENABLED = true;

  // --- LAUNCH BROWSER ---
  const browser = await puppeteer.launch({ headless: false, defaultViewport: null });
  const page = await browser.newPage();

  console.log(`Opening Aura at ${INITIAL_URL}...`);
  await page.goto(INITIAL_URL, { waitUntil: 'networkidle2' });

  // --- WAIT FOR MODEL SELECTOR ---
  await page.waitForSelector('#model-select', { timeout: 10000 });
  console.log('Model selector loaded');

  // --- SELECT MODEL ---
  await page.select('#model-select', MODEL_TO_LOAD);
  console.log(`Model selected: ${MODEL_TO_LOAD}`);

  // --- LOAD XLSL MODULE ---
  if (XLSL_ENABLED) {
    try {
      await page.waitForSelector('#xlsl-load-btn', { timeout: 5000 });
      await page.click('#xlsl-load-btn');
      console.log('XLSL module loaded');
    } catch (err) {
      console.log('XLSL module not found, skipping...');
    }
  }

  // --- AUTO CHAT LOOP ---
  const messages = [
    'Hello Aura, test connection',
    'Run XLSL analysis',
    'Show me model capabilities'
  ];

  let iteration = 0;
  for (const msg of messages) {
    if (iteration >= ITERATION_LIMIT) break;

    // TYPE MESSAGE
    await page.type('#input', msg, { delay: 50 });
    await page.click('#send');
    console.log(`Sent message: "${msg}"`);

    // WAIT FOR RESPONSE
    await page.waitForTimeout(2000); // adjust timing if responses are slow
    iteration++;
  }

  console.log('Automation finished');
  // await browser.close();
})();
