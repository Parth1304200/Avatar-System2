// server.js
const express = require('express');
const fetch = require('node-fetch');

const app = express();
const PORT = process.env.PORT || 3000;
const NODE_URL = process.env.NODE_URL || 'https://fullnode.devnet.aptos.dev/v1';
const MODULE_ADDRESS = process.env.MODULE_ADDRESS || '0xdea173ed001a4c1863d35ea52bd1cc60fa5459f8199b841c94835a6b53129274';
const MODULE_NAME = 'avatar';

app.get('/avatar/:address', async (req, res) => {
  const addr = req.params.address;
  const resourceType = `${MODULE_ADDRESS}::${MODULE_NAME}::Avatar`;
  try {
    const r = await fetch(`${NODE_URL}/accounts/${addr}/resource/${encodeURIComponent(resourceType)}`);
    if (!r.ok) {
      return res.status(404).json({ error: 'not found' });
    }
    const data = await r.json();
    // return raw resource so frontend can parse
    res.json(data);
  } catch (e) {
    res.status(500).json({ error: e.toString() });
  }
});

app.listen(PORT, () => console.log(`Server running on ${PORT}`));
