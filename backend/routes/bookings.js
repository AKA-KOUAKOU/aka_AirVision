const express = require('express');
const router = express.Router();

// In-memory bookings store (replace with a database in production)
const bookings = [];
let nextId = 1;

/**
 * GET /api/bookings
 * Returns all bookings (optionally filter by ?user=email)
 */
router.get('/', (req, res) => {
  const { user } = req.query;
  const result = user
    ? bookings.filter(b => b.user === user)
    : bookings;
  res.json(result);
});

/**
 * GET /api/bookings/:id
 * Returns a single booking by ID
 */
router.get('/:id', (req, res) => {
  const booking = bookings.find(b => b.id === parseInt(req.params.id, 10));
  if (!booking) return res.status(404).json({ error: 'Booking not found' });
  res.json(booking);
});

/**
 * POST /api/bookings
 * Creates a new booking
 * Body: { user, stylist, service, price, date, time }
 */
router.post('/', (req, res) => {
  const { user, stylist, service, price, date, time } = req.body;
  if (!user || !stylist || !service || !date || !time) {
    return res.status(400).json({ error: 'user, stylist, service, date and time are required' });
  }
  const booking = {
    id: nextId++,
    user,
    stylist,
    service,
    price: price || null,
    date,
    time,
    status: req.body.status || 'confirmed',
    createdAt: new Date(),
  };
  bookings.push(booking);
  res.status(201).json(booking);
});

/**
 * PATCH /api/bookings/:id/cancel
 * Cancels a booking
 */
router.patch('/:id/cancel', (req, res) => {
  const booking = bookings.find(b => b.id === parseInt(req.params.id, 10));
  if (!booking) return res.status(404).json({ error: 'Booking not found' });
  booking.status = 'cancelled';
  res.json(booking);
});

/**
 * DELETE /api/bookings/:id
 * Deletes a booking
 */
router.delete('/:id', (req, res) => {
  const index = bookings.findIndex(b => b.id === parseInt(req.params.id, 10));
  if (index === -1) return res.status(404).json({ error: 'Booking not found' });
  bookings.splice(index, 1);
  res.status(204).send();
});

module.exports = router;
