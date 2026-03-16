const express = require('express');
const router = express.Router();

// Seed product catalogue (replace with a database in production)
const products = [
  { id: 'prod_001', name: 'Shampoing Hydratant Premium', price: 29.99, category: 'Soin', rating: 4.5, stock: 50 },
  { id: 'prod_002', name: 'Masque Nourrissant Cheveux',  price: 39.99, category: 'Soin', rating: 4.8, stock: 30 },
  { id: 'prod_003', name: "Huile d'Argan Pure",          price: 24.99, category: 'Soin', rating: 4.7, stock: 40 },
  { id: 'prod_004', name: 'Brosse Démêlante Pro',        price: 19.99, category: 'Accessoire', rating: 4.3, stock: 60 },
  { id: 'prod_005', name: 'Spray Thermoprotecteur',      price: 17.99, category: 'Style', rating: 4.4, stock: 45 },
  { id: 'prod_006', name: 'Gel Coiffant Fort',           price: 12.99, category: 'Style', rating: 4.2, stock: 80 },
  { id: 'prod_007', name: 'Sèche-cheveux Ionique',       price: 79.99, category: 'Accessoire', rating: 4.9, stock: 20 },
  { id: 'prod_008', name: 'Après-shampoing Réparateur',  price: 22.99, category: 'Soin', rating: 4.6, stock: 35 },
];

/**
 * GET /api/products
 * Returns all products (optionally filter by ?category=Soin)
 */
router.get('/', (req, res) => {
  const { category, q } = req.query;
  let result = products;
  if (category) result = result.filter(p => p.category === category);
  if (q) result = result.filter(p => p.name.toLowerCase().includes(q.toLowerCase()));
  res.json(result);
});

/**
 * GET /api/products/:id
 * Returns a single product by ID
 */
router.get('/:id', (req, res) => {
  const product = products.find(p => p.id === req.params.id);
  if (!product) return res.status(404).json({ error: 'Product not found' });
  res.json(product);
});

/**
 * POST /api/products/order
 * Places an order (simulated – no Stripe wiring yet)
 * Body: { user, items: [{ productId, quantity }] }
 */
router.post('/order', (req, res) => {
  const { user, items } = req.body;
  if (!user || !Array.isArray(items) || items.length === 0) {
    return res.status(400).json({ error: 'user and items[] are required' });
  }

  let total = 0;
  const lineItems = [];
  for (const item of items) {
    const product = products.find(p => p.id === item.productId);
    if (!product) {
      return res.status(400).json({ error: `Product ${item.productId} not found` });
    }
    const qty = parseInt(item.quantity, 10) || 1;
    total += product.price * qty;
    lineItems.push({ product: product.name, quantity: qty, unitPrice: product.price });
  }

  res.status(201).json({
    orderId: `ORD_${Date.now()}`,
    user,
    items: lineItems,
    total: parseFloat(total.toFixed(2)),
    currency: 'EUR',
    status: 'pending_payment',
    createdAt: new Date(),
  });
});

module.exports = router;
