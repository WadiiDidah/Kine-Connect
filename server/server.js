const express = require('express');
const cors = require('cors');

const app = express();

app.use(cors());
app.use(express.json());

const patients = [
  {
    id: 1,
    firstName: 'Emma',
    lastName: 'Martin',
    email: 'emma.martin@example.com'
  },
  {
    id: 2,
    firstName: 'Lucas',
    lastName: 'Bernard',
    email: 'lucas.bernard@example.com'
  }
];

app.get('/health', (req, res) => {
  res.json({
    status: 'ok'
  });
});

app.get('/patients', (req, res) => {
  res.json(patients);
});

app.get('/patients/:id', (req, res) => {
  const id = Number(req.params.id);

  const patient = patients.find(
    patient => patient.id === id
  );

  if (!patient) {
    return res.status(404).json({
      message: 'Patient introuvable'
    });
  }

  res.json(patient);
});

app.post('/patients', (req, res) => {
  const patient = {
    id: patients.length + 1,
    ...req.body
  };

  patients.push(patient);

  res.status(201).json(patient);
});

app.listen(3000, () => {
  console.log('Kiné Connect API running on port 3000');
});